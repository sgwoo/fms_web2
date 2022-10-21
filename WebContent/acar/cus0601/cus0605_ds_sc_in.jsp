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
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	Vector vt = pk_db.getOffWashContList(off_id);
	int vt_size = vt.size();
	
	int count = 0;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//등록
	function wash_cont_reg(gubun){
		var SUBWIN="cus0605_ds_i.jsp?off_id=<%=off_id%>&gubun="+gubun;
		window.open(SUBWIN, "", "left=100, top=120, width=1100, height=170, scrollbars=no");
	}
//-->
</script>
</head>
<body>
<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr>
    	<td>
      		<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>세차</span>&nbsp;&nbsp;
      		<a href="javascript:wash_cont_reg('wash');">
  				<img src="../images/center/button_reg.gif" align="absmiddle" border="0">
  			</a>
      	</td>
  	</tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0">
            	<tr>
			        <td class=line2></td>
			    </tr>
            	<tr>
            		<td class='line' id='td_title' style='position:relative;'>
                        <table border="0" cellspacing="1" cellpadding="0" width="900">
                            <tr>
                                <td width='25%' class='title' height="35" >단가</td>
                                <td width='30%' class='title' >기준일자</td>
                                <td class='title' height="35" >적요</td>
                            </tr>
                            <% 
						    if( vt_size > 0) {
						    	count = 0;
								for(int i = 0 ; i < vt_size ; i++) {
									Hashtable ht = (Hashtable)vt.elementAt(i);
									if(String.valueOf(ht.get("GUBUN")).equals("wash")){
										count++;
							%>
								<tr> 
	                                <td align="center"><%=AddUtil.parseDecimal(ht.get("WASH_PAY"))%> <%if(ht.get("EST_ST").equals("법인사업자") || ht.get("EST_ST").equals("개인사업자")){ %>(vat 포함)<%}%></td>	                                
	                                <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APPLY_DT")))%></td>
	                                <td align="center"><%=ht.get("CONT_ETC")%></td>
	                            </tr>
							<%
									}
								}
							%>
							<%
						    }
							if(count == 0) {
							%>
								<tr> 
	                                <td align="center" colspan="3">데이터가 없습니다.</td>
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
    <tr>
    	<td></td>
    	<td></td>
    </tr>
	<tr>
    	<td>
      		<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>실내크리닝 및 냄새제거</span>&nbsp;&nbsp;
      		<a href="javascript:wash_cont_reg('inclean');">
  				<img src="../images/center/button_reg.gif" align="absmiddle" border="0">
  			</a>
      	</td>
  	</tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0">
            	<tr>
			        <td class=line2></td>
			    </tr>
            	<tr>
            		<td class='line' id='td_title' style='position:relative;'>
                        <table border="0" cellspacing="1" cellpadding="0" width="900">
                            <tr>
                                <td width='25%' class='title' height="35" >단가</td>
                                <td width='30%' class='title' >기준일자</td>
                                <td class='title' height="35" >적요</td>
                            </tr>
                            <% 
						    if( vt_size > 0) {
						    	count = 0;
								for(int i = 0 ; i < vt_size ; i++) {
									Hashtable ht = (Hashtable)vt.elementAt(i);
									if(String.valueOf(ht.get("GUBUN")).equals("inclean")){
										count++;
							%>
								<tr> 
	                                <td align="center"><%=AddUtil.parseDecimal(ht.get("WASH_PAY"))%> <%if(ht.get("EST_ST").equals("법인사업자") || ht.get("EST_ST").equals("개인사업자")){ %>(vat 포함)<%}%></td>	                                
	                                <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APPLY_DT")))%></td>
	                                <td align="center"><%=ht.get("CONT_ETC")%></td>
	                            </tr>
							<%
									}
								}
							%>
							<%
						    }
							if(count == 0) {
							%>
								<tr> 
	                                <td align="center" colspan="3">데이터가 없습니다.</td>
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
