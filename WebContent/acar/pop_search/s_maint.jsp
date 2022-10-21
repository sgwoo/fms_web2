<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ma.*"%>
<jsp:useBean id="CodeDb" class="acar.ma.CodeDatabase" scope="page"/>
<jsp:useBean id="MaOffDb" class="acar.ma.MaOffDatabase" scope="page"/>
<jsp:useBean id="MaOffBn" class="acar.beans.MaOffBean" scope="page"/>
<%@ include file="/acar/cookies_base.jsp" %>
<%
	String off_st = request.getParameter("off_st")==null?"":request.getParameter("off_st");
	
	MaOffBean[] MaOffList = MaOffDb.getMaOffList(s_kd, t_wd, off_st);	//�˻��
%>


<html>
<head><title>�˻����� ��ȸ</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function setOff(id, nm){
	pfm = opener.document.form1;
	pfm.off_id.value = id;
	pfm.off_nm.value = nm;
	this.close();
}
function setOff1(id, nm, car_comp_id, level, own_nm, ent_no, off_sta, off_itm, off_tel, zip, addr ){
	pfm = opener.document.form1;
	pfm.off_id.value = id;
	pfm.off_nm.value = nm;
	pfm.car_comp_id.value = car_comp_id;
	pfm.off_level.value = level;
	pfm.own_nm.value = own_nm;
	pfm.ent_no.value = ent_no.substring(0,3)+"-"+ent_no.substring(3,5)+"-"+ent_no.substring(5);
	pfm.off_sta.value = off_sta;
	pfm.off_itm.value = off_itm;
	pfm.off_tel.value = off_tel;
	pfm.zip.value = zip;
	pfm.addr.value = addr;
	this.close();
}
function searchMaOff(){
	fm = document.form1;
	fm.submit();
}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10">
<form name='form1' action='./s_maint.jsp' method='post'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td align='left' colspan="2"><font color="#666600">- �˻����� ��ȸ -</font></td>
    </tr>
    <!--
    <tr> 
      <td align='left'> 
        <input type="radio" name="radiobutton" value="radiobutton" checked>
        ��ü 
        <input type="radio" name="radiobutton" value="radiobutton">
        �뿩���� ������ 
        <input type="radio" name="radiobutton" value="radiobutton">
        ������� ������</td>
    </tr>-->
    <tr> 
      <td align='left'> 
        <input type="radio" name="off_st" value="1" <% if(off_st.equals("1")) out.print("checked"); %>>
        �����ü 
        <input type="radio" name="off_st" value="2" <% if(off_st.equals("2")) out.print("checked"); %>>
        �˻��
		<input type="radio" name="off_st" value="3" <% if(off_st.equals("3")) out.print("checked"); %>>
        Ź�۾�ü 
		&nbsp;&nbsp;
        <select name="s_kd">
          <option value="1" selected>��ȣ</option>
        </select>
        <input type='text' class='text' name='t_wd' value="<%= t_wd %>" size='15' >
        <a href="javascript:searchMaOff();"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a> 
      </td>
      <td align='right'><a href='./s_maint_i.jsp' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_in.gif" width="50" height="18" align="bottom" border="0" alt="���"></a></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="6%">����</td>
            <td class='title' width="39%">��ȣ</td>
            <td class='title' width="15%">��ǥ��</td>
            <td class='title' width="20%">����ڵ�Ϲ�ȣ</td>
            <td class='title' width="20%">����ó</td>
          </tr>
          <% if(MaOffList.length > 0){
		  		for(int i=0; i<MaOffList.length; i++){
					MaOffBn = MaOffList[i]; %>
          <tr> 
            <td align="center"><%= i+1 %></td>
            <td><% if(MaOffBn.getOff_st().equals("1")){ %>
					<a href="javascript:setOff1('<%= MaOffBn.getOff_id() %>','<%= MaOffBn.getOff_nm() %>','<%= CodeDb.getNameByIdCode("car_comp_id", MaOffBn.getCar_comp_id()) %>','<%= MaOffBn.getOff_level() %>','<%= MaOffBn.getOwn_nm() %>','<%= MaOffBn.getEnt_no() %>','<%= MaOffBn.getOff_sta() %>','<%= MaOffBn.getOff_itm() %>','<%= MaOffBn.getOff_tel() %>','<%= MaOffBn.getZip() %>','<%= MaOffBn.getAddr() %>');"><%= MaOffBn.getOff_nm() %></a>
				<% }else if(MaOffBn.getOff_st().equals("2")){ %>
					<a href="javascript:setOff('<%= MaOffBn.getOff_id() %>','<%= MaOffBn.getOff_nm() %>');"><%= MaOffBn.getOff_nm() %></a>					
				<% }else if(MaOffBn.getOff_st().equals("3")){ %>
				<% } %></td>
            <td align="center"><%= MaOffBn.getOwn_nm() %></td>
            <td align="center"><%= Util.ChangeEnt_no(MaOffBn.getEnt_no()) %></td>
            <td align="center"><%= MaOffBn.getOff_tel() %></td>
          </tr>
          <% 	}
		  	}else{
		   %>
          <tr> 
            <td colspan="5" align="center">�ش� �����Ͱ� �����ϴ�.</td>
          </tr>
          <% } %>
        </table>
      </td>
    </tr>
    <tr> 
      <td align='right' colspan="2"> <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="���"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
