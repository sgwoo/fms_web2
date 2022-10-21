<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*"%>
<%@ page import="acar.cus0601.*, acar.bill_mng.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//사업장현황
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	//네오엠 거래처 정보	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = c61_soBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
	
	//계약내역
	Vector vt = pk_db.getOffWashContList(off_id);
	int vt_size = vt.size();
	
	//종사원현황
	Vector vt2 = pk_db.getOffWashUserList(off_id);
	int vt_size2 = vt2.size();
	
	int count=0;
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<body leftmargin="15">
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='off_id' value='<%=off_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>									
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>차량관리 > 보유차관리 > 주차장세차현황 > <span class=style5>사업장현황</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사업장현황</span></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">
				<tr> 
                    <td class=title>상호</td>
                    <td colspan="7">&nbsp;&nbsp;<%=c61_soBn.getOff_nm()%></td>                
                </tr>
				<tr> 
                    <td class=title>구분</td>
                    <td colspan="7">&nbsp;&nbsp;<%=c61_soBn.getEst_st()%></td>                
                </tr>
                <tr> 
                    <td class=title>대표자</td>
                    <td>&nbsp;&nbsp;<%=c61_soBn.getOwn_nm()%></td>
                   <% if (c61_soBn.getEst_st().equals("개인")) { %>   
                	<td class=title>주민번호</td>  
   					<td>&nbsp;&nbsp;<%=AddUtil.ChangeEnt_no(c61_soBn.getSsn())%></td>
   			       <% } else {%> 
                    <td class=title>사업자번호</td>
                    <td>&nbsp;&nbsp;<%=AddUtil.ChangeEnt_no(c61_soBn.getEnt_no())%></td>
                   <% } %> 
                    <td class=title>업태</td>
                    <td>&nbsp;&nbsp;<%=c61_soBn.getOff_sta()%></td>
                    <td class=title>종목</td>
                    <td>&nbsp;&nbsp;<%=c61_soBn.getOff_item()%></td>
                </tr>
                <tr> 
                    <td class=title>주소</td>
                    <td align=left colspan=5>&nbsp;&nbsp;<%=c61_soBn.getOff_post()%>&nbsp;<%=c61_soBn.getOff_addr()%></td>
                    <td class=title>사무실전화</td>
                    <td>&nbsp;&nbsp;<%=c61_soBn.getOff_tel()%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>계좌개설은행</td>
                    <td width=15%>&nbsp;&nbsp;<%=c61_soBn.getBank()%></td>
                    <td class=title width=10%>계좌번호</td>
                    <td width=15%>&nbsp;&nbsp;<%=c61_soBn.getAcc_no()%></td>
                    <td class=title width=10%>예금주</td>
                    <td width=15%>&nbsp;&nbsp;<%=c61_soBn.getAcc_nm()%></td>
                    <td class=title width=10%>팩스</td>
                    <td width=15%>&nbsp;&nbsp;<%=c61_soBn.getOff_fax()%></td>
                </tr>
                <tr> 
                    <td class=title>특이사항</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<%=c61_soBn.getNote()%></td>
                </tr>
                <tr> 
                    <td class=title>네오엠거래처</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<%if(!ven_code.equals("")){%>(<%=ven_code%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%><input type="hidden" name="ven_code" value="<%= ven_code %>"></td>
                </tr>
			</table>
		</td>
    </tr>
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세차</span></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">				
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
					<td align="center"><%=AddUtil.parseDecimal(ht.get("WASH_PAY"))%> (vat 포함)</td>	                                
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
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>실내크리밍 및 냄새제거</span></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">				
				<tr>
				    <td width='25%' class='title' height="35" >단가</td>
				    <td width='30%' class='title' >기준일자</td>
				    <td class='title' height="35" >적요</td>
				</tr>
				<% 
				if( vt_size > 0) {
					count=0;
					for(int i = 0 ; i < vt_size ; i++) {
						Hashtable ht = (Hashtable)vt.elementAt(i);
						if(String.valueOf(ht.get("GUBUN")).equals("inclean")){
						count++;
				%>
				<tr> 
					<td align="center"><%=AddUtil.parseDecimal(ht.get("WASH_PAY"))%> (vat 포함)</td>	                                
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
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>종사원현황</span></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">
				<tr>
					<td width='5%' class='title' height="35" rowspan="2">연번</td>
					<td width='15%' class='title' rowspan="2">성명</td>
					<td width='15%' class='title' height="35" rowspan="2">연락처</td>
					<td class='title' height="35" rowspan="2">주소</td>
					<!-- <td width='10%' class='title' height="35" rowspan="2">주민등록등본</td>
					<td width='10%' class='title' height="35" rowspan="2">신분증사본</td> -->
					<td width='30%' class='title' height="35" colspan="2">근무현황</td>
				</tr>
				<tr>
					<td width='15%' class='title' height="35">입사일자</td>
					<td width='15%' class='title' height="35">퇴사일자</td>
				</tr>
				<% 
				if( vt_size2 > 0) {
					for(int i = 0 ; i < vt_size2 ; i++) {
						Hashtable ht2 = (Hashtable)vt2.elementAt(i);
				%>
				<tr> 
					<td align="center"><%=i+1%></td>
					<td align="center"><%=ht2.get("WASH_USER_NM")%></td>
					<td align="center"><%=ht2.get("WASH_USER_ID")%></td>
					<td align="center"><%=ht2.get("WASH_USER_ADDR")%></td>
					<!-- <td align="center"></td>
					<td align="center"></td> -->
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("WASH_USER_ENTER_DT")))%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("WASH_USER_END_DT")))%></td>
				</tr>
				<%
					}
				} else {
				%>
				<tr> 
					<td align="center" colspan="6">데이터가 없습니다.</td>
				</tr>
				<%
				}
				%>
			</table>
		</td>
    </tr>
</table>
</form>
<!-- <iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize> -->
</body>
</html>