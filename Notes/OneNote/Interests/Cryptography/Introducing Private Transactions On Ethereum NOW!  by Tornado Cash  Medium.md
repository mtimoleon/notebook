Clipped from: [https://tornado-cash.medium.com/introducing-private-transactions-on-ethereum-now-42ee915babe0](https://tornado-cash.medium.com/introducing-private-transactions-on-ethereum-now-42ee915babe0)  

By default, your entire Ethereum transaction history and balances are public. All transactions can be seen on block explorers like Etherscan, and anyone who knows that you own a particular address can easily view your payments, trace the source of your funds, calculate your holdings, and analyse your on-chain activity.

But what if you did not want your history and balances to be publicly viewed by everyone? What if you wanted anonymity and privacy, when it came to your transactions?

Over the years there have been many attempts at creating private transactions on Ethereum. Some workarounds trying to obscure value flows, like using a centralised exchange wallet or a custodial mixing service, however, introduce a high degree of counterparty and surveillance risk. In the end, these tools never achieved full privacy in the way that other privacy focused cryptocurrencies, like Zcash have. Zcash uses various cryptographic methods including implementations of Zero Knowledge proofs to achieve the privacy functionality.

Press enter or click to view image in full size

![](https://miro.medium.com/v2/resize:fit:700/1*CruZuRo9gn8sLnoONV5IEQ.png)

Today we are thrilled to share with you that is also possible on Ethereum. Our brand new tool [tornado.cash](https://tornado.cash/) allows you to send Ethereum cryptocurrency 100% anonymously using groundbreaking, non-custodial technology based on strong cryptography!

Press enter or click to view image in full size

![](https://miro.medium.com/v2/resize:fit:700/0*memKh9GO4sgc3ToJ)

## How does Tornado.cash achieve privacy in Ethereum?

Tornado improves transaction privacy by breaking the on-chain link between recipient and destination addresses. It uses a smart contract that accepts ETH deposits that can be withdrawn by a different address. Whenever ETH is withdrawn by the new address, there is **no way to link** the withdrawal to the deposit, **ensuring complete privacy.**

In this way, Tornado.cash acts as a proxy to ensure that the transaction is **100% anonymous** with zkSnarks proofs.

## Deposit

To make a deposit user generates a secret and sends its hash (called a commitment) along with deposit amount to the Tornado smart contract. The contract accepts the deposit and adds the commitment to its list of deposits.

Later, the user decides to make a withdraw. In order to do that the user should provide a proof that he or she possesses a secret to an unspent commitment from the smart contract’s list of deposits. **zkSnark** technology allows to do that without revealing which exact deposit corresponds to this secret. The smart contract will check the proof, and transfer deposited funds to the address specified for withdrawal. An external observer will be unable to determine which deposit this withdrawal comes from.

## Get Tornado Cash’s stories in your inbox

Join Medium for free to get updates from this writer.

Subscribe

That how it works. Now let us explain why the **Anonymity Set** is so important.

## Anonymity Set

Press enter or click to view image in full size

![](https://miro.medium.com/v2/resize:fit:700/0*2XogK-lOxsOcrwbM)

Anonymity set is basically a measurement of anonymity. It shows how many deposits still await for the withdrawal. In other words, how many deposits your mixed ETH value can originate from.

## The chicken or the egg problem

You may notice there are two options for the withdrawal:

- Using a wallet (Metamask, Trustwallet, etc)
- Or via Relayer

Press enter or click to view image in full size

![](https://miro.medium.com/v2/resize:fit:700/0*hQYiCEtvLxq57ao5)

The first method requires you to have a completely new Ethereum address with some ETH on it. And that poses the question.

> How to get some ETH on the address without losing anonymity?

Because usually you buy it from other people (using exchanges or not), and we want to avoid it, right?

That’s why you can use the Relayer feature to complete the process. All you need is to generate a new Ethereum address, and zkSnark proof and Relayer will do the rest. It will also charge you some ETH, just to cover Ethereum network fee.

## Tips to stay anonymous

Press enter or click to view image in full size

![](https://miro.medium.com/v2/resize:fit:700/0*2VWmA4K_0-Kr4P4G)

- Using Relayer or not, you still need to keep up common Internet anonymity like using vpn, proxies, [Tor](https://www.torproject.org/) in order to hide the IP address you act from. Since you are using browser an Incognito Tab feature is also useful.
- Make sure you clear cookies for dapps before using your new address, because if a dapp sees both old and new address with the same cookies it will know that addresses are from the same owner.
- The note contains data that can be used to link your deposit with withdraw. It is a good idea to make sure that your note data is securely destroyed after the withdrawal is complete.
- Wait until there are a few deposits after yours. If your deposit and withdrawal are right next to each other, the observer can guess that this might be the same person. We recommend waiting until there are at least 5 deposits
- Wait until some time has passed after your deposit. Even if there are multiple deposits after yours they all might be made by the same person that is trying to spam deposits and make user falsely believe that there is a large anonymity set. We recommend waiting at least 24h to make sure that there were deposits made by multiple people during that time.