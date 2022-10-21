<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.parking.*" %>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String year = request.getParameter("year")==null?"2007":request.getParameter("year");
	String month = request.getParameter("month")==null?"":request.getParameter("month");
	
	long sum_amt = 0;	
	
	Vector vt = new Vector();
	vt = pk_db.getOffWashUserList(off_id);
	int vt_size = vt.size();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	// ���
	function wash_user_reg(){
		var SUBWIN="cus0605_dm_i.jsp?off_id=<%=off_id%>";
		window.open(SUBWIN, "", "left=100, top=120, width=1100, height=360, scrollbars=no");
	}
	
	// ����
	function wash_user_modify(seq, off_id, wash_user_nm, wash_user_id, wash_user_zip, wash_user_addr, wash_user_enter_dt, wash_user_end_dt) {
		window.open("cus0605_dm_i.jsp?seq="+seq+"&off_id="+off_id+"&wash_user_nm="+wash_user_nm+"&wash_user_id="+wash_user_id+"&wash_user_zip="+wash_user_zip+"&wash_user_addr="+wash_user_addr+"&wash_user_enter_dt="+wash_user_enter_dt+"&wash_user_end_dt="+wash_user_end_dt, "������Ȳ ����", "left=100, top=120, width=1100, height=360, scrollbars=no");
	}
//-->
</script>
</head>

<body>
<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr>
    	<td>
      		<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������Ȳ</span>&nbsp;&nbsp;
      		<!-- <a href="javascript:wash_user_reg();">
  				<img src="../images/center/button_reg.gif" align="absmiddle" border="0">
  			</a> -->
      	</td>
  	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
            	<tr>
            		<td class='line' id='td_title' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='5%' class='title' height="35" rowspan="2">����</td>
                                <td width='15%' class='title' rowspan="2">����</td>
                                <td width='15%' class='title' height="35" rowspan="2">����ó</td>
                                <td class='title' height="35" rowspan="2">�ּ�</td>
                                <!-- <td width='10%' class='title' height="35" rowspan="2">�ֹε�ϵ</td>
                                <td width='10%' class='title' height="35" rowspan="2">�ź����纻</td> -->
                                <td width='30%' class='title' height="35" colspan="2">�ٹ���Ȳ</td>
                            </tr>
                            <tr>
                            	<td width='15%' class='title' height="35">�Ի�����</td>
                            	<td width='15%' class='title' height="35">�������</td>
                            </tr>
                            <% 
						    if( vt_size > 0) {
								for(int i = 0 ; i < vt_size ; i++) {
									Hashtable ht = (Hashtable)vt.elementAt(i);
							%>
								<tr> 
	                                <td align="center"><%=i+1%></td>
	                                <td align="center">
	                                	<%-- <a href="javascript:wash_user_modify('<%=ht.get("SEQ")%>', '<%=ht.get("OFF_ID")%>', '<%=ht.get("WASH_USER_NM")%>', '<%=ht.get("WASH_USER_ID")%>', '<%=ht.get("WASH_USER_ZIP")%>', '<%=ht.get("WASH_USER_ADDR")%>', '<%=ht.get("WASH_USER_ENTER_DT")%>', '<%=ht.get("WASH_USER_END_DT")%>')" onMouseOver="window.status=''; return true" hover>
	                                		<%=ht.get("WASH_USER_NM")%>
	                                	</a> --%>
	                                	<%=ht.get("WASH_USER_NM")%>
	                                </td>
	                                <td align="center"><%=ht.get("WASH_USER_ID")%></td>
	                                <td align="center"><%=ht.get("WASH_USER_ADDR")%></td>
	                                <!-- <td align="center"></td>
	                                <td align="center"></td> -->
	                                <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("WASH_USER_ENTER_DT")))%></td>
	                                <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("WASH_USER_END_DT")))%></td>
	                            </tr>
							<%
								}
							%>
							<%
							} else {
							%>
								<tr> 
	                                <td align="center" colspan="6">�����Ͱ� �����ϴ�.</td>
	                            </tr>
							<%
							}
							%>
                        </table>
                    </td>
            	</tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
