
![[image-16.png]]


![[image-17.png]]

![[image-18.png]]

![[image-19.png]]

 \[
  {
    $sort: { PublishedAt: 1, _id: 1 }
  },

  {
    $group: {
      _id: "$Id",
      FirstBatch: { $first: "$$ROOT" },
      LastBatch: { $last: "$$ROOT" },
      PublishedAt: { $first: "$PublishedAt" }
    }
  },

  {
    $sort: { _id: 1 }
  },

  {
    $facet: {
      beforeFirstDate: [
        {
          $match: {
            PublishedAt: {
              $lt: ISODate(
                "2025-10-21T12:33:28.000"
              )
            }
          }
        },
        {
          $sort: {
            PublishedAt: -1
          }
        },
        {
          $limit: 1
        },
        {
          $project: {
            _id: 0,
            Batch: "$FirstBatch"
          }
        }
      ],
      afterLastDate: [
        {
          $match: {
            PublishedAt: {
              $gte: ISODate(
                "2025-10-21T12:33:32.000"
              )
            }
          }
        },
        {
          $sort: {
            PublishedAt: 1
          }
        },
        {
          $limit: 1
        },
        {
          $project: {
            _id: 0,
            Batch: "$FirstBatch"
          }
        }
      ]
    }
  }
]

--------------------------------------------------------------------------------
Using facet
[
   {
    $facet: {
      beforeFirstDate: [
        { $sort: { Id: 1, PublishedAt: 1, _id: 1 } },
        { $group: { _id: "$Id", FirstBatch: { $first: "$$ROOT" }, IterationStart: { $first: "$PublishedAt" } } },
        { $match: { IterationStart: { $lt: ISODate('2025-10-22T07:43:14.944+00:00') } } },
        { $sort: { _id: 1 } },
        { $project: { _id: 0, Batch: "$FirstBatch" } }
      ],
      afterLastDate: [
        { $match: { PublishedAt: { $gte: ISODate('2025-10-22T07:43:15.184+00:00') } } },
        { $sort:  { Id: 1, PublishedAt: 1, _id: 1 } },
        { $group: { _id: "$Id", FirstAfter: { $first: "$$ROOT" } } },
        { $sort:  { _id: 1 } },
        { $project: { _id: 0, Batch: "$FirstAfter" } }
      ]
    }
  }
]

---------------------------------------------------------------------------------
Using unionWith
[
  { $sort: { Id: 1, PublishedAt: 1, _id: 1 } },
  { $group: {
      _id: "$Id",
      FirstBatch: { $first: "$$ROOT" },
      IterationStart: { $first: "$PublishedAt" }
  }},
// this match does not guarrantee that all batches are from the same publish
  { $match: { IterationStart: { $lt: ISODate('2025-10-22T07:43:14.944+00:00') } } },
  { $project: { _id: 0, Id: "$_id", Batch: "$FirstBatch", kind: { $literal: "beforeFirstDate" } } },

  
  { $unionWith: {
      coll: "archived-batches",
      pipeline: [
        { $match: { PublishedAt: { $type: "date", $gt: ISODate('2025-10-22T07:43:15.184+00:00') } } },
        { $sort:  { Id: 1, PublishedAt: 1, _id: 1 } },
        { $group: { _id: "$Id", FirstAfter: { $first: "$$ROOT" } } },
        { $project: { _id: 0, Id: "$_id", Batch: "$FirstAfter", kind: { $literal: "afterLastDate" } } }
      ]
  }},

  { $sort: { Id: 1, kind: 1 } }
]

---------------------------------------------------------------------------------
Corrected with lookup
[
  // Find global previous publish
  { $match: { PublishedAt: { $lt: ISODate("2025-10-22T07:43:14.944Z") } } },
  { $group: { _id: null, firstPublish: { $max: "$PublishedAt" } } },
  // FirstBatch = last doc with PublishedAt == firstPublish, per Id
  {
    $lookup: {
      from: "archived-batches",
      let: {
        fp: "$firstPublish"
      },
      pipeline: [
        { $match: { $expr: { $eq: ["$PublishedAt", "$$fp"] } } },
        { $sort: { Id: 1, _id: 1 } }, 
        { $group: { _id: "$Id", FirstBatch: { $last: "$$ROOT" } } },
        {
          // For efficiency we can do specific batch projection here
          $project: { FirstBatch: 1, LastBatch: { $literal: null } }
        }
      ],
      as: "prevRows"
    }
  },
  { $unwind: { path: "$prevRows", preserveNullAndEmptyArrays: true } },
  { $replaceRoot: { newRoot: "$prevRows" } },
  
  // LastBatch = first doc with PublishedAt >= lastDate, per Id
  {
    $unionWith: {
      coll: "archived-batches",
      pipeline: [
        {
          $match: {
            PublishedAt: {
              $gte: ISODate(
                "2025-10-22T07:43:15.184Z"
              )
            }
          }
        },
        {
          $sort: {
            Id: 1,
            PublishedAt: 1,
            _id: 1
          }
        },
        {
          $group: {
            _id: "$Id",
            LastBatch: {
              $first: "$$ROOT"
            }
          }
        },
        // For efficiency we can do specific batch projection here
        {
          $project: {
            FirstBatch: {
              $literal: null
            },
            LastBatch: 1
          }
        }
      ]
    }
  },
  {
    $group: {
      _id: "$_id",
      // $max acts as "pick non-null" if there are any null objects in the list
      FirstBatch: { $max: "$FirstBatch" },
      LastBatch: { $max: "$LastBatch" }
    }
  },
  {
    $match: {
      $expr: {
        $or: [ {$ne: ["$FirstBatch", null]}, { $ne: ["$LastBatch", null]} ]
      }
    }
  },
  {
    $sort: {
      _id: 1
    }
  },
  // If there is specific projection before there is no need to project here
  {
    $project: {
      FirstBatchId: "$FirstBatch.Id",
      FirstBatchName: "$FirstBatch.Name",
      FirstBatch: "$FirstBatch.PublishedAt",
      LastBatchId: "$LastBatch.Id",
      LastBatchName: "$LastBatch.Name",
      LastBatch: "$LastBatch.PublishedAt"
    }
  }
]


