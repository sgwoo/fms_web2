<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, card.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	//�߰� : ������ ����Ʈ
	Vector users3 = c_db.getUserList("", "", "EMP");
	int user3_size = users3.size();
	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
		
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
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
function Search(gubun){
	var fm = document.form1;
	if (gubun == "2") {
		fm.search_start.value = "Y";
	}
	fm.action="sc_doc_mng_sc.jsp";
	fm.target="c_foot";		
	fm.submit();
}
function enter() {
	var keyValue = event.keyCode;
	if (keyValue =='13') Search('2');
}	
//��������Ʈ
function GetUsetList(nm){
	var fm = document.form1;
	te = fm.gubun4;
	te.options[0].value = '';
	te.options[0].text = '��ü';
	fm.nm.value = "form1."+nm;
	fm.target = "i_no";
	fm.action = "../card_mng/user_null.jsp";
	fm.submit();
}

//���ο��� üũ�� �ŷ����� �ſ� �ʷ� �ڵ� �Է�
Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";
 
    var weekName = ["�Ͽ���", "������", "ȭ����", "������", "�����", "�ݿ���", "�����"];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "����" : "����";
            default: return $1;
        }
    });
};

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

function first_date(){
	var fm = document.form1;
	var now = new Date();
	var firstDate = new Date(now.getFullYear(), now.getMonth(), 1).format("yyyy-MM-dd");
	var endDate = new Date().format("yyyy-MM-dd");
	//	new Date().format("yyyy-MM-dd");
	
	if(fm.chk2[0].checked == true || fm.chk2[1].checked == true || fm.chk2[2].checked == true|| fm.chk2[3].checked == true) {
		if(fm.st_dt.value == "" && fm.end_dt.value == "") {
			fm.st_dt.value = firstDate;
			fm.end_dt.value= endDate;
		}
	}else{
		fm.st_dt.value = "";
		fm.end_dt.value = "";
	}
}
</script>

</head>
<body onload="javascript=Search('1');">
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
  <input type="hidden" name="search_start" value="">

<table border=0 cellspacing=0 cellpadding=0 width=100% class="search-area">
	<tr >
		<td colspan=6 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>New ī����ǥ����</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan=6  class=h></td>
	</tr>
	<tr>
	  	<!-- �Ⱓ���� -->
	    <td width="8%" class="height_td">&nbsp;
	    	<label><i class="fa fa-check-circle"></i> �Ⱓ���� </label>
	    </td>
	    <td width="35%">
			<select name="gubun1" class="select">
 				<option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>�ŷ�����</option>
				<option value="2" <%if(gubun1.equals("2")){%> selected <%}%>>�������</option>
				<option value="3" <%if(gubun1.equals("3")){%> selected <%}%>>��������</option>
			</select>&nbsp;
			<input class="input" type="text" name="st_dt" size="10" value="<%-- <%=st_dt%> --%>" class="text" onBlur="javscript:this.value = ChangeDate(this.value);">&nbsp;~&nbsp;
  	  		<input class="input" type="text" name="end_dt" size="10" value="<%-- <%=end_dt%> --%>" class="text" onBlur="javscript:this.value = ChangeDate(this.value);">
		</td>
		<!-- ������ -->
		<td width="8%">&nbsp;
			<label><i class="fa fa-check-circle"></i> ������ </label>
	    </td>
	    <td width="12%">
		    <%	
		    if(user3_size > 0){
				for (int i = 0 ; i < user3_size ; i++){
					Hashtable user3 = (Hashtable)users3.elementAt(i);	
					
					if(user_id.equals(user3.get("USER_ID"))){
						user_nm = (String)user3.get("USER_NM");
					}
				}
			}
			%>
			<input class="input" type='text' name='gubun7' value='<%=user_nm%>' size="10" <%if(!nm_db.getWorkAuthUser("�ӿ�",user_id) && !nm_db.getWorkAuthUser("ȸ�����",user_id) && !nm_db.getWorkAuthUser("������",user_id)){%>readonly<%}%> >
    	</td>
	     <!-- ����� -->
		<td width="8%">&nbsp;
			<label><i class="fa fa-check-circle"></i> ����� </label>
	    </td>
	    <td width="29%">			
			<input class="input" type='text' name='gubun4' value='<%-- <%=user_nm%> --%>' size="10">				
		</td>
	</tr>
	<tr>
	
		<!-- �μ��� -->
		<td class="height_td">&nbsp;
			<label><i class="fa fa-check-circle"></i> �μ��� </label>
	    </td>
	    <td>
			<select name='gubun3' class="select" >
				<option value=''>��ü</option>
				<%
				for(int i = 0 ; i < dept_size ; i++){
					CodeBean dept = depts[i];%>
				<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
				<%	
				}%>
			</select>
		</td>
			<!-- �����Ҹ� ī�������� -->
			<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> ī������  </label>
	    </td>
	    <td>
			<select name='gubun2' class="select" >
			  <option value=''>��ü</option>
          <%	if(ck_size > 0){
					for (int i = 0 ; i < ck_size ; i++){
						Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
          <option value='<%= card_kind.get("CARD_KIND") %>' <%if(gubun2.equals(String.valueOf(card_kind.get("CARD_KIND")))){%>selected<%}%>><%= card_kind.get("CARD_KIND") %></option>
          <%		}
				}%>
        </select>        
		
		</td>
		
		<!-- ī�� -->
		<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> ī�� </label>
	    </td>
	    <td>
			<input class="input" type="text" name="t_wd1" class="text" value='<%=t_wd1%>' onKeyDown='javascript:enter()' style='IME-MODE: active' size='15'>&nbsp;
			<span class="style2">(ī���ȣ,�����ڱ���) </span>
		</td>
		<!-- <td align="right">&nbsp;</td> -->
	</tr>
	<tr>
		<!-- ����ȸ -->
		<td class="height_td">&nbsp;
			<label><i class="fa fa-check-circle"></i> ����ȸ </label>
	    </td>
	    <td>
			<select name='s_kd' class="select">
				<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>�ŷ�ó </option>
				<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>���� </option>
				<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>���� </option>
				<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>�ݾ� </option>
			</select>&nbsp;
			<input class="input" type='text' name='t_wd2' size='25' class='text' value='<%=t_wd2%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		</td>
		<!-- ������ -->
		<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> ������ </label>
	    </td>
	    <td>
			<select name='gubun5' class="select">
				<option value="0">��ü</option>
				<%	
				if(cmi_size > 0){
					for (int i = 0 ; i < cmi_size ; i++){
						Hashtable card_m_id = (Hashtable)card_m_ids.elementAt(i);%>
				<option value='<%= card_m_id.get("USER_ID") %>' <%if(gubun5.equals(String.valueOf(card_m_id.get("USER_ID")))){%>selected<%}%>><%= card_m_id.get("USER_NM") %></option>
				<%}
				}%>
			</select>
		</td>
		<!-- ������ -->
		<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> ������ </label>
	    </td>
	    <td>
			<select name='gubun6' class="select">
			<option value="0">��ü</option>
			<%
			if(cdi_size > 0){
				for (int i = 0 ; i < cdi_size ; i++){
					Hashtable card_d_id = (Hashtable)card_d_ids.elementAt(i);%>
			<option value='<%= card_d_id.get("USER_ID") %>' <%if(gubun6.equals(String.valueOf(card_d_id.get("USER_ID")))){%>selected<%}%>><%= card_d_id.get("USER_NM") %></option>
			<%}
			}%>
			</select>
		</td>
		<!-- <td align="right">&nbsp;</td> -->
	</tr>	
    <tr>
    	<!-- ���ο��� -->
		<td class="height_td">&nbsp;
			<label><i class="fa fa-check-circle"></i> ���ο��� </label>
	    </td>
	    <td style="vertical-align:middle;">
			<input type="radio" name="chk2" value="" <%if(chk2.equals("")){%> checked <%}%> onClick="javascript:first_date();">��ü 
			<input type="radio" name="chk2" value="4" <%if(chk2.equals("4")){%> checked <%}%> onClick="javascript:first_date();">���
			<input type="radio" name="chk2" value="1" <%if(chk2.equals("1")){%> checked <%}%> onClick="javascript:first_date();">����
			<input type="radio" name="chk2" value="2" <%if(chk2.equals("2")){%> checked <%}%> onClick="javascript:first_date();">�̽���
			<input type="radio" name="chk2" value="3" <%if(chk2.equals("3")){%> checked <%}%> onClick="javascript:first_date();">�̵��
		</td>
    	<!-- �������� -->
		<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> �������� </label>
	    </td>
	    <td colspan="3">
			<input type="radio" name="chk1" value="" <%if(chk1.equals("")){%> checked <%}%>>��ü
			<input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>�Ϲݰ���
			<input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>���̰���
			<input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>�鼼
			<input type="radio" name="chk1" value="4" <%if(chk1.equals("4")){%> checked <%}%>>�񿵸�����(�������/��ü)
			<input type="button" class="button" value="�˻�" onclick="javascript:Search('2');">
		</td>	
		<!-- <td align="right">&nbsp;</td> -->
 	</tr>	 
	<tr>
		<td colspan=6  class=h></td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
