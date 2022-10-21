<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, card.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//������ ����Ʈ ��ȸ
	Vector branches = c_db.getBranchs();
	int brch_size = branches.size();
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	//�߰� : ������ ����Ʈ
	Vector users3 = c_db.getUserList("", "", "EMP");
	int user3_size = users3.size();
	
	
	//�ڵ� ����:�μ���-����������
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	//ī������� ����Ʈ ��ȸ
	Vector card_m_ids = CardDb.getCardMngIds("card_mng_id", "", "Y");
	int cmi_size = card_m_ids.size();
	//��ǥ������ ����Ʈ ��ȸ
	Vector card_d_ids = CardDb.getCardMngIds("doc_mng_id", "", "Y");
	int cdi_size = card_d_ids.size();
	String user_nm = "";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="doc_mng_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
	
//-->
</script>

</head>
<body onload="javascript=Search();">
<form action="" name="form1" method="POST">

  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_url" value="/tax/scd_mng/scd_mng_sc.jsp">      
  <input type="hidden" name="nm" value="">

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td colspan=5><table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>ī����ǥ��ȸ</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gggub.gif" title="�Ⱓ����">&nbsp;&nbsp;
          <select name="gubun1" >
            <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>�ŷ�����&nbsp;</option>
            <option value="2" <%if(gubun1.equals("2")){%> selected <%}%>>�ۼ�����&nbsp;</option>
            <option value="3" <%if(gubun1.equals("3")){%> selected <%}%>>��������&nbsp;</option>
            <option value="4" <%if(gubun1.equals("4")){%> selected <%}%>>�������ذŷ���&nbsp;</option>
          </select>
          <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		  &nbsp;~&nbsp;
      	  <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">
      </td>
      <td><img src="/acar/images/center/arrow_gjgm.gif" title="��������">&nbsp;
          <select name='gubun2'>
            <option value="">��ü</option>
            <option value="00001" <%if(gubun2.equals("00001")){%> selected <%}%>>�����Ļ���</option>
            <option value="00002" <%if(gubun2.equals("00002")){%> selected <%}%>>�����</option>
            <option value="00003" <%if(gubun2.equals("00003")){%> selected <%}%>>�������</option>
            <option value="00004" <%if(gubun2.equals("00004")){%> selected <%}%>>����������</option>
            <option value="00005" <%if(gubun2.equals("00005")){%> selected <%}%>>���������</option>
            <option value="00006" <%if(gubun2.equals("00006")){%> selected <%}%>>���������</option>
            <option value="00007" <%if(gubun2.equals("00007")){%> selected <%}%>>�繫��ǰ��</option>
            <option value="00008" <%if(gubun2.equals("00008")){%> selected <%}%>>�Ҹ�ǰ��</option>
            <option value="00009" <%if(gubun2.equals("00009")){%> selected <%}%>>��ź�</option>
            <option value="00010" <%if(gubun2.equals("00010")){%> selected <%}%>>�����μ��</option>
            <option value="00011" <%if(gubun2.equals("00011")){%> selected <%}%>>���޼�����</option>
            <option value="00012" <%if(gubun2.equals("00012")){%> selected <%}%>>��ǰ</option>
            <option value="00013" <%if(gubun2.equals("00013")){%> selected <%}%>>���ޱ�</option>
            <option value="00014" <%if(gubun2.equals("00014")){%> selected <%}%>>�����Ʒú�</option>
			<option value="00015" <%if(gubun2.equals("00015")){%> selected <%}%>>���ݰ�����</option>		  
			<option value="00016" <%if(gubun2.equals("00016")){%> selected <%}%>>�뿩�������</option>		  
			<option value="00017" <%if(gubun2.equals("00017")){%> selected <%}%>>�����������</option>	
			<option value="00018" <%if(gubun2.equals("00018")){%> selected <%}%>>��ݺ�</option>	
			<option value="00019" <%if(gubun2.equals("00019")){%> selected <%}%>>�������</option>			  						
        </select></td>
      <td width="30%">
        <img src="/acar/images/center/arrow_drj.gif" title="�����" >&nbsp;
       <input type='text' name='gubun8' value='<%=gubun8%>' size="15">	
        </td>
      <td width="8%" align="right"></td>
    </tr>
    <tr>
      <td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yus.gif" title="������">&nbsp;&nbsp;&nbsp;&nbsp;
          <select name='s_br'>
            <option value=''>��ü</option>
            <%	if(brch_size > 0){
					for (int i = 0 ; i < brch_size ; i++){
						Hashtable branch = (Hashtable)branches.elementAt(i);%>
            <option value='<%= branch.get("BR_ID") %>' <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
            <%		}
				}%>
          </select>
      </td>
      <td width="17%"><img src="/acar/images/center/arrow_bsm.gif" title="�μ���">&nbsp;
          <select name='gubun3'>
            <option value=''>��ü</option>
            <%for(int i = 0 ; i < dept_size ; i++){
				CodeBean dept = depts[i];%>
            <option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
            <%	
				}%>
          </select>
      </td>
      <td><img src="/acar/images/center/arrow_syj.gif" title="�����">&nbsp;&nbsp;&nbsp;&nbsp;
            <%	if(user_size > 0){
					for (int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i);
							if(user_id.equals(user.get("USER_ID"))){
								user_nm = (String)user.get("USER_NM");
							}
					}
				}%>
 			<input type='text' name='gubun4' value='<%=user_nm%>' size="15" <%if(!nm_db.getWorkAuthUser("�ӿ�",user_id) && !nm_db.getWorkAuthUser("ȸ�����",user_id) && !nm_db.getWorkAuthUser("������",user_id)){%>readonly<%}%> >			
      </td>
      <td><img src="/acar/images/center/arrow_suj.gif" title="������">&nbsp;
   	
          <%	if(user3_size > 0){
						for (int i = 0 ; i < user3_size ; i++){
							Hashtable user3 = (Hashtable)users3.elementAt(i);	
							if(user_id.equals(user3.get("USER_ID"))){
								user_nm = (String)user3.get("USER_NM");
							}
						}
					}
							%>
          <input type='text' name='gubun7' value='<%=user_nm%>' size="15" <%if(!nm_db.getWorkAuthUser("�ӿ�",user_id) && !nm_db.getWorkAuthUser("ȸ�����",user_id) && !nm_db.getWorkAuthUser("������",user_id)){%>readonly<%}%> >
        </td>
      <td align="right"><div align="left">      </div></td>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_glj.gif" title="������">&nbsp;&nbsp;&nbsp;&nbsp;
          <select name='gubun5'>
            <option value="0">��ü</option>
            <%	if(cmi_size > 0){
					for (int i = 0 ; i < cmi_size ; i++){
						Hashtable card_m_id = (Hashtable)card_m_ids.elementAt(i);%>
            <option value='<%= card_m_id.get("USER_ID") %>' <%if(gubun5.equals(String.valueOf(card_m_id.get("USER_ID")))){%>selected<%}%>><%= card_m_id.get("USER_NM") %></option>
            <%		}
				}%>
        </select></td>
      <td><img src="/acar/images/center/arrow_sij.gif" title="������">&nbsp;
          <select name='gubun6'>
            <option value="0">��ü</option>
            <%	if(cdi_size > 0){
					for (int i = 0 ; i < cdi_size ; i++){
						Hashtable card_d_id = (Hashtable)card_d_ids.elementAt(i);%>
            <option value='<%= card_d_id.get("USER_ID") %>' <%if(gubun6.equals(String.valueOf(card_d_id.get("USER_ID")))){%>selected<%}%>><%= card_d_id.get("USER_NM") %></option>
            <%	}
				}%>
        </select></td>
      <td colspan="2"><img src="/acar/images/center/arrow_card.gif" title="ī�� ��ȸ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="text" name="t_wd1" class="text" value='<%=t_wd1%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
&nbsp;<span class="style2">(ī���ȣ,�����ڱ���) </span></td>
      <td align="right">&nbsp;</td>
    </tr>	
    <tr>
      <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ssjh.gif" align=absmiddle title="�󼼰˻�">&nbsp;&nbsp;
        <select name='s_kd'>
            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>�ŷ�ó </option>
			<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>���� </option>
			<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>���� </option>
			<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>�ݾ� </option>
        </select>
		&nbsp;&nbsp;&nbsp;
        <input type='text' name='t_wd2' size='25' class='text' value='<%=t_wd2%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	  </td>
      <td colspan="2"><img src="/acar/images/center/arrow_gsuh.gif" align=absmiddle title="��������">&nbsp;
        <input type="radio" name="chk1" value="" <%if(chk1.equals("")){%> checked <%}%>>
      ��ü
      <input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>
      �Ϲݰ���
      <input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>
      ���̰���
      <input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>
      �鼼
      <input type="radio" name="chk1" value="4" <%if(chk1.equals("4")){%> checked <%}%>>
      �񿵸�����(�������/��ü)
	  </td>	  
      <td align="right">&nbsp;</td>
    </tr>		
    <tr>
      <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_siyb.gif" title="���ο���">&nbsp;
      <input type="radio" name="chk2" value="" <%if(chk2.equals("")){%> checked <%}%>>
      ��ü
      <input type="radio" name="chk2" value="Y" <%if(chk2.equals("Y")){%> checked <%}%>>
      ����
      <input type="radio" name="chk2" value="N" <%if(chk2.equals("N")){%> checked <%}%>>
      �̽��� 
       (�������)
       /
      <input type="radio" name="chk2" value="C" <%if(chk2.equals("C")){%> checked <%}%>>
      ��� 
      </td>
<!--	  
      <td width="25%" colspan=""><img src="/acar/images/center/arrow_g_cg.gif" title="û������">&nbsp;
      	
      <input type="radio" name="cgs_ok" value="" <%if(cgs_ok.equals("")){%> checked <%}%>>
      ��ü      	
      <input type="radio" name="cgs_ok" value="1" <%if(cgs_ok.equals("1")){%> checked <%}%>>
      ����
      <input type="radio" name="cgs_ok" value="2" <%if(cgs_ok.equals("2")){%> checked <%}%>>
      ����
      <input type="radio" name="cgs_ok" value="3" <%if(cgs_ok.equals("3")){%> checked <%}%>>
      ���� </td>
    --> 
      <td><div align="right"><a href="javascript:Search();" ><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></div></td>
    </tr>	
    	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>