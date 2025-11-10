// © 2021 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
// This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
// http://aws.amazon.com/agreement or other written agreement between Customer and either
// Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
/* eslint-disable jsx-a11y/anchor-is-valid */
import React, { useState } from "react";
import Alert from "@awsui/components-react/alert";
import "../../index.css";
import params from "../../parameters.json";
import { Auth } from "aws-amplify";
import TopNavigation from "@awsui/components-react/top-navigation";
import { useHistory } from "react-router-dom";

function Header(props) {
  const history = useHistory();
  const [visible, setVisible] = useState(false);

  async function signOut() {
    try {
      await Auth.signOut();
    } catch (error) {
      console.log("error signing out");
    }
  }

  function Notification() {
    return (
      <Alert
        dismissible
        statusIconAriaLabel="Info"
        header="Feature announcement"
        visible={visible}
        onDismiss={() => setVisible(false)}
      >
        🚀 TEAM v1.5.0 introduces possibility to approve only selected permission set and create multiple eligibility policies per team.
      </Alert>
    );
  }

  return (
    <div>
      <TopNavigation
        identity={{
          href: "/",
          logo: {
            src: "/logo.png",
            alt: "TEAM",
          },
        }}
        utilities={[
          {
            type: "button",
            iconName: "notification",
            title: "Notifications",
            ariaLabel: "Notifications (unread)",
            badge: true,
            disableUtilityCollapse: false,
            onClick: () => setVisible(true),
          },
          {
            type: "button",
            text: "v1.5.0",
            href: "https://github.com/idnowgmbh/io.idnow.infrastructure.iam-team",
            external: true,
            externalIconAriaLabel: " (opens in a new tab)",
          },
          {
            type: "menu-dropdown",
            text: `${props.user}`,
            description: `${props.user}`,
            iconName: "user-profile",
            onItemClick: ({ detail }) => {
              if (detail.id === "signout") {
                signOut().then(() => history.push("/"));
              }
            },
            items: [
              { id: "signout", text: "Sign out" }
            ],
          },
        ]}
        onFollow={() => {
          history.push("/");
          props.setActiveHref("/");
          props.addNotification([]);
        }}
      />
      <Notification />
    </div>
  );
}

export default Header;
