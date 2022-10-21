<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.arrear.ArrearDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"4":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	int total_su 	= 0;
	long total_amt 	= 0;
	long total_amt2 = 0;
	
	
	
	Vector fees = af_db.getFeeList1(br_id, gubun1, gubun2, gubun3, "4", st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int fee_size = fees.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=fee_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='50%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='15%' class='title'>연번</td>
                    <td width='15%' class='title'>구분</td>
                    <td width='24%' class='title'>계약번호</td>
                    <td width='31%' class='title'>상호</td>
                    <td width='15%' class='title'>차량번호</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='50%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='20%' class='title'>차명</td>
                    <td width='16%' class='title'>입금예정일</td>
                    <td width='20%' class='title'>연체금액</td>
                    <td width='12%' class='title'>연체일수</td>
                    <td width='10%' class='title'>영업소</td>
                    <td width='12%' class='title'>영업담당</td>
                    <td width='10%' class='title'>진행</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(fee_size > 0){%>
    <tr>
	    <td class='line' width='50%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for (int i = 0 ; i < fee_size ; i++){
				Hashtable fee = (Hashtable)fees.elementAt(i);%>
                <tr> 
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=15% align='center'><a name="<%=i+1%>"><%=i+1%><%if(fee.get("USE_YN").equals("N"))%>(해약)<%%></a></td>
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=15% align='center'><a href="javascript:parent.view_memo('<%=fee.get("RENT_MNG_ID")%>', '<%=fee.get("RENT_L_CD")%>', '<%=fee.get("RENT_ST")%>', '', '','')" onMouseOver="window.status=''; return true">미수금</a></td>			
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=24% align='center'><a href="javascript:parent.view_fee('<%=fee.get("RENT_MNG_ID")%>', '<%=fee.get("RENT_L_CD")%>', '<%=fee.get("CAR_MNG_ID")%>', '<%=i%>')" onMouseOver="window.status=''; return true"><%=fee.get("RENT_L_CD")%></a></td>
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=31% align='center'><span title='<%=fee.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=fee.get("RENT_MNG_ID")%>', '<%=fee.get("RENT_L_CD")%>', '<%=fee.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(fee.get("FIRM_NM")), 9)%></a></span></td>
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=15% align='center'><span title='<%=fee.get("CAR_NO")%>'><%=Util.subData(String.valueOf(fee.get("CAR_NO")), 15)%></span></td>
                </tr>
          <%	total_su 	= total_su + 1;
				total_amt 	= total_amt + Long.parseLong(String.valueOf(fee.get("FEE_AMT")));
			}%>
                <tr> 
                    <td class="title" align='center'>현황</td>
        		    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" align='center'>합계</td>
                    <td class="title">&nbsp;</td>
          
                </tr>
            </table>
        </td>
	    <td class='line' width='50%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for (int i = 0 ; i < fee_size ; i++){
				Hashtable fee = (Hashtable)fees.elementAt(i);%>
                <tr> 
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=20% align='center'><span title='<%=fee.get("CAR_NM")%>'><%=Util.subData(String.valueOf(fee.get("CAR_NM")), 5)%></span></td>
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=16% align='center'><%=AddUtil.ChangeDate2(String.valueOf(fee.get("FEE_EST_DT")))%></td>
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=20%' align='right'><%=Util.parseDecimal(String.valueOf(fee.get("FEE_AMT")))%></td>
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=12% align='right'><%=fee.get("DLY_DAYS")%>일&nbsp;</td>
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=10% align='center'><%=fee.get("BRCH_ID")%></td>
                    <td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width=12% align='center'><%=fee.get("BUS_NM2")%></td>
                	<td width=10% align='center'>
                    <% if (fee.get("CREDIT_METHOD").equals("1") || fee.get("CREDIT_METHOD").equals("2")) { %>
                     <a href="javascript:parent.view_credit('<%=fee.get("RENT_MNG_ID")%>', '<%=fee.get("RENT_L_CD")%>', '1')"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
                    <% } else if ( auth_rw.equals("4") ||  auth_rw.equals("5") ||  auth_rw.equals("6")) {%> 
                    <a href="javascript:parent.reg_credit('<%=fee.get("RENT_MNG_ID")%>', '<%=fee.get("RENT_L_CD")%>')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
                    <% } %>
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		  
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='50%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='50%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<% 	}%>
</table>
</form>
</body>
</html>
