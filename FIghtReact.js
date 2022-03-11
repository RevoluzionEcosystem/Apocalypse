import { useState , useEffect } from "react";
import { useMoralis, useMoralisWeb3Api, useMoralisWeb3ApiCall, useWeb3ExecuteFunction } from "react-moralis";

const imgCharacterURL = "https://app.apocgame.io/NFT/character";
const imgMobsterURL = "https://app.apocgame.io/NFT/mobster";

const CHARACTER = process.env.REACT_APP_CHARACTER;
const WEAPON = process.env.REACT_APP_WEAPON;
const GAME = process.env.REACT_APP_GAME;
const REWARD_POOL = process.env.REACT_APP_REWARD_POOL;

const FightSlot1 = ({ethAddress}) => {

    const ERC20_ABI = [
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "name": "getBaseAttack",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "attack",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "address",
                    "name": "_address",
                    "type": "address"
                }
            ],
            "name": "getWeaponSlot1",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [],
            "name": "fightSlot1",
            "outputs": [
                {
                    "internalType": "bool",
                    "name": "status",
                    "type": "bool"
                },
                {
                    "internalType": "uint256",
                    "name": "drop",
                    "type": "uint256"
                }
            ],
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "address",
                    "name": "address",
                    "type": "address"
                }
            ],
            "name": "rewards",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "totalReceived",
                    "type": "uint256"
                },
                {
                    "internalType": "uint256",
                    "name": "totalAccumulated",
                    "type": "uint256"
                },
                {
                    "internalType": "uint256",
                    "name": "currentLimit",
                    "type": "uint256"
                },
                {
                    "internalType": "uint256",
                    "name": "limitReset",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "name": "getCharXP",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "XP",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "name": "getCharHP",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "HP",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "name": "getCharLevel",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "Level",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "name": "getAngelModifier",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "Angel",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "name": "getCharSkill",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "Skill",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "name": "getCharType",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "Type",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                }
            ],
            "name": "getCharStatus",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "Status",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_tokenID",
                    "type": "uint256"
                },
                {
                    "internalType": "uint256",
                    "name": "_weaponAttack",
                    "type": "uint256"
                }
            ],
            "name": "getSuccessRate",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "Rate",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [],
            "name": "hpRequireBase",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "HP",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "address",
                    "name": "_address",
                    "type": "address"
                }
            ],
            "name": "getCharSlot1",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "tokenID",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
    ]

    const { Moralis } = useMoralis();
    const contractProcessor = useWeb3ExecuteFunction();
    const {native: { runContractFunction },} = useMoralisWeb3Api();

    const [ isNFT, setIsNFT ] = useState(true);    

    const toggleDisplayStyle = () => setIsNFT(false);
    useEffect(() => {loadCheckCharSlot()}, [!isNFT]);


    const getCharSlot = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: GAME,
        function_name: "getCharSlot1",
        abi: ERC20_ABI,
        params: {
            _address: ethAddress
        }
    });
    const { data : dataCharSlot } = getCharSlot;

    const getWeaponSlot = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: GAME,
        function_name: "getWeaponSlot1",
        abi: ERC20_ABI,
        params: {
            _address: ethAddress
        }
    });
    const { data : dataWeaponSlot } = getWeaponSlot;

    const getWeaponAttack = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: WEAPON,
        function_name: "getBaseAttack",
        abi: ERC20_ABI,
        params: {
            _tokenID: dataWeaponSlot
        }
    });
    const { data : dataWeaponAttack } = getWeaponAttack;

    const fetchHPRequiredBase = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: GAME,
        function_name: "hpRequireBase",
        abi: ERC20_ABI,
    });
    const { data : hpRequireBase } = fetchHPRequiredBase;

    const fetchSuccessRate = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: GAME,
        function_name: "getSuccessRate",
        abi: ERC20_ABI,
        params: {
            _tokenID: dataCharSlot,
            _weaponAttack: dataWeaponAttack
        }
    });
    const { data : successRate } = fetchSuccessRate;

    const fetchCharStatus = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: CHARACTER,
        function_name: "getCharStatus",
        abi: ERC20_ABI,
        params:{
            _tokenID: dataCharSlot
        }
    });
    const { data : charStatus } = fetchCharStatus;

    const fetchCharType = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: CHARACTER,
        function_name: "getCharType",
        abi: ERC20_ABI,
        params:{
            _tokenID: dataCharSlot
        }
    });
    const { data : charType } = fetchCharType;

    const fetchCharSkill = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: CHARACTER,
        function_name: "getCharSkill",
        abi: ERC20_ABI,
        params:{
            _tokenID: dataCharSlot
        }
    });
    const { data : charSkill } = fetchCharSkill;

    const fetchCharAngelModifier = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: CHARACTER,
        function_name: "getAngelModifier",
        abi: ERC20_ABI,
        params:{
            _tokenID: dataCharSlot
        }
    });
    const { data : charAngelModifier } = fetchCharAngelModifier;

    const fetchCharLevel = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: CHARACTER,
        function_name: "getCharLevel",
        abi: ERC20_ABI,
        params:{
            _tokenID: dataCharSlot
        }
    });
    const { data : charLevel } = fetchCharLevel;

    const fetchCharHP = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: CHARACTER,
        function_name: "getCharHP",
        abi: ERC20_ABI,
        params:{
            _tokenID: dataCharSlot
        }
    });
    const { data : charHP } = fetchCharHP;

    const fetchCharXP = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: CHARACTER,
        function_name: "getCharXP",
        abi: ERC20_ABI,
        params:{
            _tokenID: dataCharSlot
        }
    });
    const { data : charXP } = fetchCharXP;

    const fetchRewards = useMoralisWeb3ApiCall(runContractFunction, {
        chain: "bsc",
        address: REWARD_POOL,
        function_name: "rewards",
        abi: ERC20_ABI,
        params: { address : ethAddress }
    });
    const { data : formattedRewards } = fetchRewards;


    const loadCheckCharSlot = () => {
        getCharSlot.fetch({data : dataCharSlot})

        getWeaponSlot.fetch({data : dataWeaponSlot})

        getWeaponAttack.fetch({data : dataWeaponAttack})

        fetchCharLevel.fetch({data : charLevel})
        
        fetchCharStatus.fetch({data : charStatus})
        
        fetchCharType.fetch({data : charType})
        
        fetchCharSkill.fetch({data : charSkill})
        
        fetchCharAngelModifier.fetch({data : charAngelModifier})
        
        fetchCharHP.fetch({data : charHP})
        
        fetchCharXP.fetch({data : charXP})

        fetchSuccessRate.fetch({data : successRate})
        
        fetchRewards.fetch({data : formattedRewards})
        
        toggleDisplayStyle(false);
    };

    const charIMG = imgCharacterURL + "/" + charAngelModifier + "/" + charStatus + "/" + charType + "/" + charSkill + ".png";
    const mobIMG = imgMobsterURL + "/" + charLevel + ".png";

    const charHPRequireBase = Number(charLevel - 1) * 10 + Number(hpRequireBase);
    const cleanSuccessRate = successRate / 100;
    
    const initiateFight = async () => {

        const web3 = await Moralis.Web3.enableWeb3();
      
        try {
          await web3.currentProvider.request({
            method: "wallet_switchEthereumChain",
            params: [{ chainId: "0x38" }],
          });
          _initiateFight();
        } catch (error) {
          if (error.code === 4902) {
            try {
              await web3.currentProvider.request({
                method: "wallet_addEthereumChain",
                params: [
                  {
                    chainId: "0x38",
                    chainName: "Binance Smart Chain Mainnet",
                    rpcUrls: ["https://bsc-dataseed.binance.org/"],
                    nativeCurrency: {
                      name: "BNB",
                      symbol: "BNB",
                      decimals: 18,
                    },
                    blockExplorerUrls: ["https://bscscan.com"],
                  },
                ],
              });
              _initiateFight();
            } catch (error) {
              alert(error.message);
            }
          }
        }
    }

    const _initiateFight = async () => {
      
        const fight = {
          chain: "bsc",
          contractAddress: GAME,
          functionName: "fightSlot1",
          abi: ERC20_ABI,
        };
        
        await contractProcessor.fetch({
          params: fight,
          onSuccess: () => {
            console.log("Fight Initiated");
            loadCheckCharSlot()
          },
          onError: (error) => {
            console.log("Fight Failed");
          },
        });
        
        
    }

    return (


        <div className="x-grid x-container max width e50-104 m1e-5 m1e-6 m1e-8 m1e-e m1e-q m1e-r m1e-v">
            <div className="x-cell e50-105 m1e-11 m1e-12 m1e-14 m1e-15 m1e-16 m1e-17 m1e-18 m1e-19 m1e-1a m1e-1b m1e-1d m1e-1f m1e-1k m1e-2d m1e-2e">
                <span className="tk-trajan-color x-image e50-106 m1e-2t m1e-2v" style={{lineHeight: "1.5",color:"rgb(186,154,4)",fontSize:"calc(12px + (12 - 9) * ((100vw - 324px) / (1980 - 324)))", textAlign:"center"}}>
                    Character ID : {dataCharSlot}
                    <br/>
                    Current HP : {charHP}
                    <br/>
                    Current XP : {charXP}
                    <img onClick={() => loadCheckCharSlot()} src={isNFT ? "https://app.apocgame.io/NFT/character/null/null/null/null.png" : charIMG } width="1094" height="2202.5" alt="Click here to refresh the image!"/>
                </span>
            </div>
            <div className="x-cell e50-107 m1e-11 m1e-12 m1e-14 m1e-15 m1e-16 m1e-17 m1e-18 m1e-1b m1e-1d m1e-1f m1e-1k m1e-1x m1e-2e m1e-2f m1e-2g">
                <span className="tk-trajan-color x-image e50-108 m1e-2t m1e-2v" style={{color:"rgb(186,154,4)",fontSize:"calc(12px + (12 - 9) * ((100vw - 324px) / (1980 - 324)))", textAlign:"center"}}>
                    <img onClick={() => loadCheckCharSlot()} src={isNFT ? "https://fly4holiday.com/wp-content/uploads/2022/02/Main-Frame.png" : mobIMG } width="2188" height="3280" alt="Click here to refresh the image!"/>
                </span>
            </div>
            <div className="x-cell e50-109 m1e-11 m1e-12 m1e-14 m1e-15 m1e-16 m1e-18 m1e-1b m1e-1d m1e-1t m1e-1w m1e-26 m1e-27 m1e-2h m1e-1 m1e-3" data-x-effect="{&quot;durationBase&quot;:&quot;300ms&quot;}">
                <a onClick={initiateFight} className="x-image e50-110 m1e-2t m1e-2v">
                    <img src="https://fly4holiday.com/wp-content/uploads/2022/02/FightIcon.png" width="251" height="329" alt="Let's fight!"/>
                </a>
                <br/>
                <span onClick={() => loadCheckCharSlot()} className="tk-trajan-color" style={{color:"rgb(186,154,4)",fontSize:"calc(12px + (12 - 9) * ((100vw - 324px) / (1980 - 324)))", textAlign:"center"}}>
                    Accumulated rewards :
                    <br/>
                    {formattedRewards ? (formattedRewards.totalAccumulated / 1000000000000000000).toFixed(2) + " BUSD" : "Click to Refresh"}
                </span>
            </div>
            <div className="x-cell e50-111 m1e-11 m1e-12 m1e-13 m1e-15 m1e-18 m1e-1f m1e-1j m1e-1k m1e-1m m1e-1w m1e-26 m1e-27 m1e-2a m1e-2g m1e-2i gradient-border-gold">
                <div className="x-grid x-container max width e50-112 m1e-5 m1e-6 m1e-8 m1e-e m1e-g m1e-p m1e-t m1e-w">
                    <div className="x-cell e50-113 m1e-11 m1e-12 m1e-14 m1e-15 m1e-16 m1e-18 m1e-1a m1e-1b m1e-1d m1e-1f m1e-1t m1e-22 m1e-26 m1e-2b m1e-2j">
                        <div className="x-text x-text-headline e50-114 m1e-3u m1e-3w m1e-3y m1e-3z tk-trajan-color">
                            <div className="x-text-content">
                                <div className="x-text-content-text">
                                    <h1 className="x-text-content-text-primary">Info</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="x-cell e50-115 m1e-10 m1e-11 m1e-12 m1e-15 m1e-16 m1e-18 m1e-1d m1e-2b m1e-2c">
                        <div className="x-text x-text-headline e50-116 m1e-3u m1e-3w m1e-3z m1e-41 tk-trajan-color">
                            <div className="x-text-content">
                                <div className="x-text-content-text">
                                    <h1 className="x-text-content-text-primary">HP required</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="x-cell e50-117 m1e-10 m1e-11 m1e-12 m1e-15 m1e-16 m1e-18 m1e-1d m1e-2b m1e-2c">
                        <div className="x-text x-text-headline e50-118 m1e-3u m1e-3w m1e-3z m1e-41 tk-trajan-color">
                            <div className="x-text-content">
                                <div className="x-text-content-text">
                                    <h1 className="x-text-content-text-primary">{charHPRequireBase} HP</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="x-cell e50-119 m1e-10 m1e-11 m1e-12 m1e-15 m1e-16 m1e-18 m1e-1d m1e-2b m1e-2c">
                        <div className="x-text x-text-headline e50-120 m1e-3u m1e-3w m1e-3z m1e-41 tk-trajan-color">
                            <div className="x-text-content">
                                <div className="x-text-content-text">
                                    <h1 className="x-text-content-text-primary">Success rate</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="x-cell e50-121 m1e-10 m1e-11 m1e-12 m1e-15 m1e-16 m1e-18 m1e-1d m1e-2b m1e-2c">
                        <div className="x-text x-text-headline e50-122 m1e-3u m1e-3w m1e-3z m1e-41 tk-trajan-color">
                            <div className="x-text-content">
                                <div className="x-text-content-text">
                                    <h1 className="x-text-content-text-primary">{cleanSuccessRate} %</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="x-cell e50-123 m1e-10 m1e-11 m1e-12 m1e-15 m1e-16 m1e-18 m1e-1d m1e-2b m1e-2c">
                        <div className="x-text x-text-headline e50-124 m1e-3u m1e-3w m1e-3z m1e-41 tk-trajan-color">
                            <div className="x-text-content">
                                <div className="x-text-content-text">
                                    <h1 className="x-text-content-text-primary">Rewards</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="x-cell e50-125 m1e-10 m1e-11 m1e-12 m1e-15 m1e-16 m1e-18 m1e-1d m1e-2b m1e-2c">
                        <div className="x-text x-text-headline e50-126 m1e-3u m1e-3w m1e-3z m1e-41 tk-trajan-color">
                            <div className="x-text-content">
                                <div className="x-text-content-text">
                                    <h1 className="x-text-content-text-primary">{charLevel} BUSD</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    );

};


export default FightSlot1;
