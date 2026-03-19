---
title: Back Up a Self-Managed Deployment with Filesystem Snapshots - Database Manual - MongoDB Docs
categories: "[[Resources]]"
created: 2026-02-17
published:
source: https://www.mongodb.com/docs/manual/tutorial/backup-with-filesystem-snapshots/
author:
  - "[[MongoDB Documentation Team]]"
description: This page details how a helpful assistant processes user prompts, focusing on JSON output formatting, key-value pairs, and Markdown string values, ensuring concise and accurate responses per instructions.
tags:
  - topic/databases
  - tech/MongoDB
---
[Docs Home](https://www.mongodb.com/docs/)
[Management](https://www.mongodb.com/docs/management)
[Backup and Restore](https://www.mongodb.com/docs/manual/core/backups)

## Back Up a Self-Managed Deployment with Filesystem Snapshots

This document describes a procedure for creating backups of MongoDB standalone servers and replica sets using system-level tools, such as [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM) or storage appliance, as well as the corresponding restoration strategies. For information on sharded clusters, see [Back Up a Self-Managed Sharded Cluster with File System Snapshots.](https://www.mongodb.com/docs/manual/tutorial/backup-sharded-cluster-with-filesystem-snapshots/#std-label-backup-sharded-lvm)

These filesystem snapshots, or "block-level" backup methods, use system level tools to create copies of the device that holds MongoDB's data files. These methods complete quickly and work reliably, but require additional system configuration outside of MongoDB.

## Tip

- [Backup Methods for a Self-Managed Deployment](https://www.mongodb.com/docs/manual/core/backups/)
- [Back Up and Restore a Self-Managed Deployment with MongoDB Tools](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/)

## Snapshots Overview

Snapshots work by creating pointers between the live data and a special snapshot volume. These pointers are theoretically equivalent to "hard links." As the working data diverges from the snapshot, the snapshot process uses a copy-on-write strategy. As a result, the snapshot only stores modified data.

After making the snapshot, you mount the snapshot image on your file system and copy data from the snapshot. The resulting backup contains a full copy of all data.

## Considerations

### WiredTiger Storage Engine

MongoDB supports volume-level back up using the [WiredTiger](https://www.mongodb.com/docs/manual/core/wiredtiger/#std-label-storage-wiredtiger) storage engine when the MongoDB instance's data files and journal files reside on separate volumes. However, to create a coherent backup, the database must be locked and all writes to the database must be suspended during the backup process.

### Encrypted Storage Engine (MongoDB Enterprise Only)

For [encrypted storage engines](https://www.mongodb.com/docs/manual/core/security-encryption-at-rest/#std-label-encrypted-storage-engine) that use `AES256-GCM` encryption mode, `AES256-GCM` requires that every process use a unique counter block value with the key.

For [encrypted storage engine](https://www.mongodb.com/docs/manual/core/security-encryption-at-rest/#std-label-encrypted-storage-engine) configured with `AES256-GCM` cipher:

- Restoring from Hot Backup
	Starting in 4.2, if you restore from files taken via "hot" backup (i.e. the [`mongod`](https://www.mongodb.com/docs/manual/reference/program/mongod/#mongodb-binary-bin.mongod) is running), MongoDB can detect "dirty" keys on startup and automatically rollover the database key to avoid IV (Initialization Vector) reuse.
- Restoring from Cold Backup
	However, if you restore from files taken via "cold" backup (i.e. the [`mongod`](https://www.mongodb.com/docs/manual/reference/program/mongod/#mongodb-binary-bin.mongod) is not running), MongoDB cannot detect "dirty" keys on startup, and reuse of IV voids confidentiality and integrity guarantees.
	Starting in 4.2, to avoid the reuse of the keys after restoring from a cold filesystem snapshot, MongoDB adds a new command-line option [`--eseDatabaseKeyRollover`](https://www.mongodb.com/docs/manual/reference/program/mongod/#std-option-mongod.--eseDatabaseKeyRollover). When started with the [`--eseDatabaseKeyRollover`](https://www.mongodb.com/docs/manual/reference/program/mongod/#std-option-mongod.--eseDatabaseKeyRollover) option, the [`mongod`](https://www.mongodb.com/docs/manual/reference/program/mongod/#mongodb-binary-bin.mongod) instance rolls over the database keys configured with `AES256-GCM` cipher and exits.

### Valid Database at the Time of Snapshot

The database must be valid when the snapshot takes place. This means that all writes accepted by the database need to be fully written to disk: either to the [journal](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-journal) or to data files.

If there are writes that are not on disk when the backup occurs, the backup will not reflect these changes.

For the WiredTiger storage engine, the data files reflect a consistent state as of the last [checkpoint](https://www.mongodb.com/docs/manual/core/wiredtiger/#std-label-storage-wiredtiger-checkpoints). Checkpoints occur with every 2 GB of data or every minute.

#### Stale Data

Backups provide a snapshot of the current state of the database. When you restore from a backup, the restored database doesn't include any changes made after the backup was taken, which can result in data loss.

### Entire Disk Image

Snapshots create an image of an entire disk image. Unless you need to back up your entire system, consider isolating your MongoDB data files, journal (if applicable), and configuration on one logical disk that doesn't contain any other data.

Alternately, store all MongoDB data files on a dedicated device so that you can make backups without duplicating extraneous data.

### Site Failure Precaution

Ensure that you copy data from snapshots onto other systems. This ensures that data is safe from site failures.

### No Incremental Backups

This tutorial does not include procedures for incremental backups. Although different snapshot methods provide different features, the LVM method outlined below does not provide any capacity for capturing incremental backups.

### Snapshots on Linux

If you manage your own infrastructure on a Linux-based system, configure your system with [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM) to provide your disk packages and provide snapshot capability. You can also use LVM-based setups *within* a cloud/virtualized environment.

## Note

Running [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM) provides additional flexibility and enables the possibility of using snapshots to back up MongoDB.

### Snapshots with Amazon EBS in a RAID 10 Configuration

If your deployment depends on Amazon's Elastic Block Storage (EBS) with RAID configured within your instance, it is impossible to get a consistent state across all disks using the platform's snapshot tool. As an alternative, you can do one of the following:

- Flush all writes to disk and create a write lock to ensure consistent state during the backup process.
	If you choose this option see [Back up Instances with Journal Files on Separate Volume or without Journaling.](https://www.mongodb.com/docs/manual/tutorial/backup-with-filesystem-snapshots/#std-label-backup-without-journaling)
- Configure [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM) to run and hold your MongoDB data files on top of the RAID within your system.
	If you choose this option, perform the LVM backup operation described in [Create a Snapshot.](https://www.mongodb.com/docs/manual/tutorial/backup-with-filesystem-snapshots/#std-label-lvm-backup-operation)

## Back Up and Restore Using LVM on Linux

This section provides an overview of a simple backup process using [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM) on a Linux system. While the tools, commands, and paths may be (slightly) different on your system the following steps provide a high level overview of the backup operation.

## Note

Only use the following procedure as a guideline for a backup system and infrastructure. Production backup systems must consider a number of application specific requirements and factors unique to specific environments.

For information on sharded clusters, see [Back Up a Self-Managed Sharded Cluster with File System Snapshots.](https://www.mongodb.com/docs/manual/tutorial/backup-sharded-cluster-with-filesystem-snapshots/#std-label-backup-sharded-lvm)

### Create a Snapshot

For the purpose of volume-level backup of MongoDB instances using WiredTiger, the data files and the journal are no longer required to reside on a single volume.

To create a snapshot with [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM), issue a command as root in the following format:

```bash
lvcreate --size 100M --snapshot --name mdb-snap01 /dev/vg0/mongodb
```

This command creates an [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM) snapshot (with the `--snapshot` option) named `mdb-snap01` of the `mongodb` volume in the `vg0` volume group.

This example creates a snapshot named `mdb-snap01` located at `/dev/vg0/mdb-snap01`. The location and paths to your systems volume groups and devices may vary slightly depending on your operating system's [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM) configuration.

The snapshot has a cap of at 100 megabytes, because of the parameter `--size 100M`. This size does not reflect the total amount of the data on the disk, but rather the quantity of differences between the current state of `/dev/vg0/mongodb` and the creation of the snapshot (i.e. `/dev/vg0/mdb-snap01`.)

## Warning

Ensure that you create snapshots with enough space to account for data growth, particularly for the period of time that it takes to copy data out of the system or to a temporary image.

If your snapshot runs out of space, the snapshot image becomes unusable. Discard this logical volume and create another.

The snapshot will exist when the command returns. You can restore directly from the snapshot at any time or by creating a new logical volume and restoring from this snapshot to the alternate image.

While snapshots are great for creating high quality backups quickly, they are not ideal as a format for storing backup data. Snapshots typically depend and reside on the same storage infrastructure as the original disk images. Therefore, it's crucial that you archive these snapshots and store them elsewhere.

### Archive a Snapshot

After creating a snapshot, mount the snapshot and copy the data to separate storage. Your system might try to compress the backup images as you move them offline. Alternatively, take a block level copy of the snapshot image, such as with the following procedure:

```bash
umount /dev/vg0/mdb-snap01dd if=/dev/vg0/mdb-snap01 | gzip > mdb-snap01.gz
```

The above command sequence does the following:

- Ensures that the `/dev/vg0/mdb-snap01` device is not mounted. Never take a block level copy of a filesystem or filesystem snapshot that is mounted.
- Performs a block level copy of the entire snapshot image using the `dd` command and compresses the result in a gzipped file in the current working directory.
	## Warning
	This command will create a large `gz` file in your current working directory. Make sure that you run this command in a file system that has enough free space.

### Restore a Snapshot

To restore a snapshot created with [LVM](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-LVM), issue the following sequence of commands:

```bash
lvcreate --size 1G --name mdb-new vg0gzip -d -c mdb-snap01.gz | dd of=/dev/vg0/mdb-newmount /dev/vg0/mdb-new /srv/mongodb
```

The above sequence does the following:

- Creates a new logical volume named `mdb-new`, in the `/dev/vg0` volume group. The path to the new device will be `/dev/vg0/mdb-new`.
	## Warning
	This volume will have a maximum size of 1 gigabyte. The original file system must have had a total size of 1 gigabyte or smaller, or else the restoration will fail.
	Change `1G` to your desired volume size.
- Uncompresses and unarchives the `mdb-snap01.gz` into the `mdb-new` disk image.
- Mounts the `mdb-new` disk image to the `/srv/mongodb` directory. Modify the mount point to correspond to your MongoDB data file location, or other location as needed.

## Note

The restored snapshot will have a stale `mongod.lock` file. If you do not remove this file from the snapshot, and MongoDB may assume that the stale lock file indicates an unclean shutdown. If you use [`db.fsyncLock()`](https://www.mongodb.com/docs/manual/reference/method/db.fsyncLock/#mongodb-method-db.fsyncLock) you will need to remove the `mongod.lock` file.

### Restore Directly from a Snapshot

To restore a backup without writing to a compressed `gz` file, use the following sequence of commands:

```bash
umount /dev/vg0/mdb-snap01lvcreate --size 1G --name mdb-new vg0dd if=/dev/vg0/mdb-snap01 of=/dev/vg0/mdb-newmount /dev/vg0/mdb-new /srv/mongodb
```

## Note

All MongoDB collections have UUIDs by default. When MongoDB restores collections, the restored collections retain their original UUIDs. When restoring a collection where no UUID was present, MongoDB generates a UUID for the restored collection.

For more information on collection UUIDs, see [Collections.](https://www.mongodb.com/docs/manual/core/databases-and-collections/#std-label-collections)

### Remote Backup Storage

You can implement off-system backups using the [combined process](https://www.mongodb.com/docs/manual/tutorial/backup-with-filesystem-snapshots/#std-label-backup-restore-from-snapshot) and SSH.

This sequence is identical to procedures explained above, except that it archives and compresses the backup on a remote system using SSH.

Consider the following procedure:

```bash
umount /dev/vg0/mdb-snap01dd if=/dev/vg0/mdb-snap01 | ssh username@example.com gzip > /opt/backup/mdb-snap01.gzlvcreate --size 1G --name mdb-new vg0ssh username@example.com gzip -d -c /opt/backup/mdb-snap01.gz | dd of=/dev/vg0/mdb-newmount /dev/vg0/mdb-new /srv/mongodb
```

## Back up Instances with Journal Files on Separate Volume or without Journaling

For the purpose of volume-level backup of MongoDB instances using WiredTiger, the data files and the journal are no longer required to reside on a single volume. However, the database must be locked and all writes to the database must be suspended during the backup process to ensure the consistency of the backup.

If your [`mongod`](https://www.mongodb.com/docs/manual/reference/program/mongod/#mongodb-binary-bin.mongod) instance has the journal files on a separate volume, you must flush all writes to disk and lock the database to prevent writes during the backup process. If you have a [replica set](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-replica-set) configuration, then for your backup use a [secondary](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-secondary) which is not receiving reads (i.e. [hidden member](https://www.mongodb.com/docs/manual/reference/glossary/#std-term-hidden-member)).

1

### Flush writes to disk and lock the database to prevent further writes.

To flush writes to disk and to "lock" the database, issue the [`db.fsyncLock()`](https://www.mongodb.com/docs/manual/reference/method/db.fsyncLock/#mongodb-method-db.fsyncLock) method in [`mongosh`:](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh)

```javascript
db.fsyncLock();
```

2

### Perform the backup operation described in.

3

### After you create the snapshot, unlock the database.

To unlock the database after you create the snapshot, use the following command in [`mongosh`:](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh)

```javascript
db.fsyncUnlock();
```[Back](https://www.mongodb.com/docs/manual/core/backups/ "Previous Section")

[

Backup and Restore

](https://www.mongodb.com/docs/manual/core/backups/ "Previous Section")[Next](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/ "Next Section")

[

Back Up and Restore with MongoDB Tools

](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/ "Next Section")

![](https://trkn.us/pixel/conv/ppt=25790;g=sitewide;gid=65909;ord=1771341434886x6aw08pe48p)