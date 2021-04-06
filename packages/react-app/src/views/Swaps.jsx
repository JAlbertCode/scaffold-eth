/* eslint-disable jsx-a11y/accessible-emoji */

import React, { useState } from "react";
import { Button, List, Divider, Input, Card, DatePicker, Slider, Switch, Progress, Spin } from "antd";
import { SyncOutlined } from '@ant-design/icons';
import { Address, Balance, Swap } from "../components";
import { parseEther, formatEther } from "@ethersproject/units";

export default function ExampleUI({purpose, setPurposeEvents, address, mainnetProvider, userProvider, localProvider, yourLocalBalance, price, tx, readContracts, writeContracts }) {

  const [newPurpose, setNewPurpose] = useState("loading...");

  return (
    <div>
      {/*
        ⚙️ Here is an example UI that displays and sets the purpose in your smart contract:
      */}
      <div style={{border:"1px solid #cccccc", padding:16, width:400, margin:"auto",marginTop:64}}>

        {  /* use formatEther to display a BigNumber: */ }
        <h2>Your Balance: {yourLocalBalance?formatEther(yourLocalBalance):"..."} ETH</h2>
        <Balance
          address={address}
          provider={localProvider}
          price={price}
        />

        <Divider/>

      </div>

      <div>
      
      </div>

      {/*
        📑 Maybe display a list of events?
          (uncomment the event and emit line in YourContract.sol! )
      */}
      <div style={{ width:600, margin: "auto", marginTop:32, paddingBottom:32 }}>
        <h2>Events:</h2>
        <List
          bordered
          dataSource={setPurposeEvents}
          renderItem={(item) => {
            return (
              <List.Item key={item.blockNumber+"_"+item.sender+"_"+item.purpose}>
                <Address
                    address={item[0]}
                    ensProvider={mainnetProvider}
                    fontSize={16}
                  /> =>
                {item[1]}
              </List.Item>
            )
          }}
        />
      </div>


      <div style={{ width:600, margin: "auto", marginTop:32, paddingBottom:256 }}>

        
      </div>


    </div>
  );
}
