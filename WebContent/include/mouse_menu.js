 	menuItems = new Array();
 	menuItemNum = 0;

 	function addMenuItem(text, url, img){
  		if(img) 		menuItems[menuItemNum] = new Array(text, url, img);
  		else if(text) 	menuItems[menuItemNum] = new Array(text, url);
  		else 			menuItems[menuItemNum] = new Array();
  		menuItemNum++;
 	}

 	menuWidth 	= 148; 	//�޴������� ����ũ��
 	menuHeight = 176; 	//�޴������� ����ũ��
 	menuDelay 	= 50; 	//���ڰ� �������� �����ð�
 	menuSpeed 	= 8; 	//�޴����ڰ� ������ �ӵ�
 	menuOffset = 2; 	//���콺 �������� ��ġ

 	addMenuItem("�ڷ�","javascript:history.back(1)");
 	addMenuItem("������","javascript:history.go(+1)");
 	addMenuItem(); //���� �и� �ٸ����...
 	addMenuItem("����! �ڸ���","http://kr.yahoo.com");
 	addMenuItem("�Ѹ���.��","http://www.hanmail.net");
 	addMenuItem("�����ڽ� �ڸ���","http://www.lycos.co.kr");
 	addMenuItem(); //���� �и� �ٸ����...

	if(window.navigator.appName == "Microsoft Internet Explorer" && window.navigator.appVersion.substring(window.navigator.appVersion.indexOf("MSIE") + 5, window.navigator.appVersion.indexOf("MSIE") + 8) >= 5.5)
  		isIe = 1;
 	else
  		isIe = 0;

 	if(isIe){
  		menuContent = '<table id="rightMenu" width="0" height="0" cellspacing="0" cellpadding="0" style="font:menu;color:menutext;"><tr height="1"><td style="background:threedlightshadow" colspan="4"></td><td style="background:threeddarkshadow"></td></tr><tr height="1"><td style="background:threedlightshadow"></td><td style="background:threedhighlight" colspan="2"></td><td style="background:threedshadow"></td><td style="background:threeddarkshadow"></td></tr><tr height="10"><td style="background:threedlightshadow"></td><td style="background:threedhighlight"></td><td style="background:threedface"><table cellspacing="0" cellpadding="0" nowrap style="font:menu;color:menutext;cursor:default;">';
  		for(m=0;m<menuItems.length;m++){
   			if(menuItems[m][0] && menuItems[m][2])	//if(img)
    			menuContent += '<tr height="17" onMouseOver="this.style.background=\'highlight\';this.style.color=\'highlighttext\';" onMouseOut="this.style.background=\'threedface\';this.style.color=\'menutext\';" onClick="parent.window.location.href=\'' + menuItems[m][1] + '\'"><td style="background:threedface" width="1" nowrap></td><td width="21" nowrap><img src="' + menuItems[m][2] + '"></td><td nowrap>' + menuItems[m][0] + '</td><td width="21" nowrap></td><td style="background:threedface" width="1" nowrap></td></tr>';
   			else if(menuItems[m][0])				//if(text)
    			menuContent += '<tr height="17" onMouseOver="this.style.background=\'highlight\';this.style.color=\'highlighttext\';" onMouseOut="this.style.background=\'threedface\';this.style.color=\'menutext\';" onClick="parent.window.location.href=\'' + menuItems[m][1] + '\'"><td style="background:threedface" width="1" nowrap></td><td width="21" nowrap></td><td nowrap>' + menuItems[m][0] + '</td><td width="21" nowrap></td><td style="background:threedface" width="1" nowrap></td></tr>';
   			else									//�и�����
    			menuContent += '<tr><td colspan="5" height="4"></td></tr><tr><td colspan="5"><table cellspacing="0"><tr><td width="2" height="1"></td><td width="0" height="1" style="background:threedshadow"></td><td width="2" height="1"></td></tr><tr><td width="2" height="1"></td><td width="100%" height="1" style="background:threedhighlight"></td><td width="2" height="1"></td></tr></table></td></tr><tr><td colspan="5" height="3"></td></tr>';
  		}
		//�߰�
  		menuContent += '<tr height="17" onMouseOver="this.style.background=\'highlight\';this.style.color=\'highlighttext\';" onMouseOut="this.style.background=\'threedface\';this.style.color=\'menutext\';" onClick="this.style.behavior=\'url(#default#homepage)\'; this.setHomePage(\'http://www.naver.com/\');"><td style="background:threedface" width="1" nowrap></td><td width="21" nowrap></td><td nowrap> ���̹� ���������� </td><td width="21" nowrap></td><td style="background:threedface" width="1" nowrap></td></tr><tr height="17" onMouseOver="this.style.background=\'highlight\';this.style.color=\'highlighttext\';" onMouseOut="this.style.background=\'threedface\';this.style.color=\'menutext\';" onClick="window.external.AddFavorite(\'http://www.naver.com\', \'���̹� - ���ı��� ã���ִ� �˻�, ���̹�\');"><td style="background:threedface" width="1" nowrap></td><td width="21" nowrap></td><td nowrap> ���̹� ���ã�� </td><td width="21" nowrap></td><td style="background:threedface" width="1" nowrap></td></tr></table></td><td style="background:threedshadow"></td><td style="background:threeddarkshadow"></td></tr><tr height="1"><td style="background:threedlightshadow"></td><td style="background:threedhighlight"></td><td style="background:threedface"></td><td style="background:threedshadow"></td><td style="background:threeddarkshadow"></td></tr><tr height="1"><td style="background:threedlightshadow"></td><td style="background:threedshadow" colspan="3"></td><td style="background:threeddarkshadow"></td></tr><tr height="1"><td style="background:threeddarkshadow" colspan="5"></td></tr></table>';

  		menuPopup = window.createPopup();
  		menuPopup.document.body.innerHTML = menuContent;
 	}

 	function showMenu(){
  		menuXPos = event.clientX + menuOffset;
  		menuYPos = event.clientY + menuOffset;

  		menuXIncrement = menuWidth / menuSpeed;
  		menuYIncrement = menuHeight / menuSpeed;

  		menuTimer = setTimeout("openMenu(0,0)", menuDelay);

  		return false;
 	}

 	function openMenu(height, width){
  		iHeight = height;
  		iWidth = width;

  		menuPopup.show(menuXPos, menuYPos, iWidth, iHeight, document.body);

  		if(iHeight < menuHeight)
   			menuTimer = setTimeout("openMenu(iHeight + menuYIncrement, iWidth + menuXIncrement)", 1);
  		else
   			clearTimeout(menuTimer);
 	}

 	if(isIe) document.oncontextmenu = showMenu;