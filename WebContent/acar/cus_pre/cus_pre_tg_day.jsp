






<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		fm.target = 'd_content';
		fm.action = 'cus0400_main.jsp';		
		fm.submit();	
	}

	//���÷��� Ÿ��
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){
			td_br_id.style.display = '';
			td_mng_id.style.display = 'none';
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){
			td_br_id.style.display = 'none';
			td_mng_id.style.display = '';
		}else{
			td_br_id.style.display = 'none';
			td_mng_id.style.display = 'none';
		}
		//search();
	}
	
	//���� ������ ����Ʈ �̵�
	function list_move(gubun1, gubun2, gubun3)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = gubun1;
		fm.gubun2.value = gubun2;
		fm.gubun3.value = gubun3;
		
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){		//������
			fm.t_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){	//���������
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;			
		}else{
			fm.t_wd.value = '';					
		}
		
		var idx = gubun1;
		if(idx == '21') 	  url = "/acar/cus0401/cus0401_s_frame.jsp";
		else if(idx == '22') url = "/acar/cus0402/cus0402_s_frame.jsp";
		else if(idx == '23') url = "/acar/cus0403/cus0403_s_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
-->
</script>
</head>

<body>
<form name='form1' method='post' action='cus0400_main.jsp'>
  <table width="800" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="800" height="20" colspan="2" class=line> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="330">&lt; ������Ȳ &gt;</td>
            <td width="10" rowspan="5">&nbsp;</td>
            <td width="460">&lt; ���� ����������Ȳ &gt;</td>
          </tr>
          <tr> 
            <td class=line width="330"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td width="90" class='title' align="center">����</td>
                  <td width="120" class='title' align="center">�ŷ�ó</td>
                  <td width="120" class='title' align="center">�ڵ���</td>
                </tr>
                <tr> 
                  <td class='title' align="center">�ܵ�����</td>
                  <td align="center"> <a href="#">30��</a></td>
                  <td align="center"> <a href="#">30��</a></td>
                </tr>
                <tr> 
                  <td class='title' align="center">��������</td>
                  <td align="center"><a href="#">7��</a></td>
                  <td align="center"><a href="#">7��</a></td>
                </tr>
                <tr> 
                  <td class='title' align="center">�հ�</td>
                  <td align="center"><a href="#">37��</a></td>
                  <td align="center"><a href="#">37��</a></td>
                </tr>
              </table></td>
            <td class=line rowspan="4"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                  <td class=title>�ŷ�ó�湮</td>
                  <td class=title>�ڵ�������</td>
                </tr>
                <tr> 
                  <td> <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr> 
                        <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                          <br> <font size="1">100</font> </td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="20" valign="bottom" align="center"><a href="#">37��</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="100"><img src=../../images/menu_back2.gif width=30 height=100></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="19" valign="bottom" align="center"><a href="#">30��</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="81"><img src=../../images/menu_back.gif width=30 height=81></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="68" valign="bottom" align="center"><a href="#">12��</a></td>
                            </tr>
                            <tr> 
                              <td height="32" valign="bottom"><img src=../../images/result1.gif width=30 height=32></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">��ü</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">����</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">�ǽ�</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="center">&nbsp;</td>
                        <td colspan="7" align="center"><font color="#999900">�ǽ��� 
                          32.43%</font><br> <br></td>
                      </tr>
                    </table></td>
                  <td> <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr> 
                        <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                          <br> <font size="1">100</font> </td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="20" valign="bottom" align="center"><a href="#">37��</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="100"><img src=../../images/menu_back2.gif width=30 height=100></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="19" valign="bottom" align="center"><a href="#">30��</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="81"><img src=../../images/menu_back.gif width=30 height=81></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="68" valign="bottom" align="center"><a href="#">12��</a></td>
                            </tr>
                            <tr> 
                              <td height="32" valign="bottom"><img src=../../images/result1.gif width=30 height=32></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">��ü</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">����</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">�ǽ�</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="center">&nbsp;</td>
                        <td colspan="7" align="center"><font color="#999900">�ǽ��� 
                          32.43%</font><br> <br></td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td width="330">&nbsp;</td>
          </tr>
          <tr> 
            <td class=line width="330"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td width="90" class=title>����</td>
                  <td width="80" class=title>�Ϲݽ�</td>
                  <td width="80" class=title>�⺻��/�����</td>
                  <td class=title width="80">�հ�</td>
                </tr>
                <tr> 
                  <td class=title>����</td>
                  <td align="center"><a href="#">8��</a></td>
                  <td align="center"><a href="#">8��</a></td>
                  <td align="center"><a href="#">19��</a></td>
                </tr>
                <tr> 
                  <td class=title>��Ʈ</td>
                  <td align="center"><a href="#">44��</a></td>
                  <td align="center"><a href="#">0��</a></td>
                  <td align="center"><a href="#">43��</a></td>
                </tr>
                <tr> 
                  <td class=title>�հ�</td>
                  <td align="center"><a href="#">52��</a></td>
                  <td align="center"><a href="#">8��</a></td>
                  <td align="center"><a href="#">72��</a></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; ���� ������Ȳ &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="30" rowspan="3">����</td>
            <td class='title' align="center" width="80" rowspan="3">����</td>
            <td rowspan="3" class='title' align="center" width="95">�ѽǽ���</td>
            <td class='title' align="center" colspan="3">�ŷ�ó�湮</td>
            <td class='title' align="center" colspan="5">�ڵ�������</td>
            <td class='title' align="center" colspan="3">����/���а˻�</td>
            <td class='title' align="center" colspan="3">�������û</td>
          </tr>
          <tr> 
            <td width="40" class='title' align="center" rowspan="2">����</td>
            <td width="40" class='title' align="center" rowspan="2">�ǽ�</td>
            <td width="50" class='title' align="center" rowspan="2">�ǽ���</td>
            <td width="40" class='title' align="center" rowspan="2">����</td>
            <td class='title' align="center" colspan="3">�ǽ�(�ǽ���)</td>
            <td width="50" class='title' align="center" rowspan="2">�ǽ���</td>
            <td width="40" class='title' align="center" rowspan="2">����</td>
            <td width="40" class='title' align="center" rowspan="2">�ǽ�</td>
            <td width="45" class='title' align="center" rowspan="2">�ǽ���</td>
            <td width="40" class='title' align="center" rowspan="2">����</td>
            <td width="40" class='title' align="center" rowspan="2">�ǽ�</td>
            <td width="50" class='title' align="center" rowspan="2">�ǽ���</td>
          </tr>
          <tr> 
            <td width="40" class='title' align="center">����</td>
            <td width="40" class='title' align="center">����</td>
            <td width="40" class='title' align="center">��</td>
          </tr>
          <tr> 
            <td align="center">1</td>
            <td align="center"><a href="stat_p.htm" target="_blank">�̱���</a></td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">2</td>
            <td align="center">Ȳ����</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">3</td>
            <td align="center">�豤��</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">4</td>
            <td align="center">���ؿ�</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">5</td>
            <td align="center">������</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">6</td>
            <td align="center">���</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center" height="22">7</td>
            <td align="center" height="22">����ȣ</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">8</td>
            <td align="center">���ֿ�</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' align="center">&nbsp;</td>
            <td class='title' align="center">�հ�</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; ���� ��ຯ����Ȳ &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="100">�ű԰�ళ��</td>
            <td align="center" width="300">5��</td>
            <td class='title' align="center" width="100">��ุ�ᵵ��</td>
            <td width="300" align="center">1��</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; ���� ����/����������Ȳ &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="30" rowspan="2">����</td>
            <td class='title' align="center" width="80" rowspan="2">����</td>
            <td class='title' align="center" width="90" rowspan="2">�հ�</td>
            <td class='title' align="center" colspan="2">�ܱ�뿩</td>
            <td class='title' align="center" colspan="2">�������</td>
            <td class='title' align="center" colspan="2">��������</td>
            <td class='title' align="center" colspan="2">�������</td>
            <td class='title' align="center" colspan="2">������</td>
            <td class='title' align="center" colspan="2">��������</td>
          </tr>
          <tr> 
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
          </tr>
          <tr> 
            <td align="center">1</td>
            <td align="center">�̱���</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">2</td>
            <td align="center">Ȳ����</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">3</td>
            <td align="center">�豤��</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">4</td>
            <td align="center">���ؿ�</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">5</td>
            <td align="center">������</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">6</td>
            <td align="center">���</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center" height="22">7</td>
            <td align="center" height="22">����ȣ</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">8</td>
            <td align="center">���ֿ�</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' align="center">&nbsp;</td>
            <td class='title' align="center">�հ�</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
</body>
</html>
<script language="JavaScript">
	//cng_input()
</script>
