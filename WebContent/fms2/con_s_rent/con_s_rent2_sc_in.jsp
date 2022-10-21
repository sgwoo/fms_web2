<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	long total_amt1 = 0;	
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	
	Vector vt = rs_db.getConSRent2SettleList(gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int vt_size = vt.size();
%>

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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">


<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1430'>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='500' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=60 rowspan="2" class='title'>연번</td>
                    <td width=60 rowspan="2" class='title'>구분</td>
                    <td width=100 rowspan="2" class='title'>계약번호</td>
                    <td width=100 rowspan="2" class='title'>상호</td>
                    <td colspan="2" class='title'>정비차량</td>
                </tr>
                <tr>
                  <td width=80 class='title'>차량번호</td>
                  <td width=100 class='title'>차명</td>
                </tr>
            </table>
        </td>
	<td class='line' width='930'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td colspan="2" class='title'>대차차량</td>
                    <td width=80 rowspan="2" class='title'>대차기간</td>
                    <td colspan="3" class='title'>청구금액</td>
                    <td width=80 rowspan="2" class='title'>입금예정일</td>
                    <td width=60 rowspan="2" class='title'>회차</td>
		    <td width=80 rowspan="2" class='title'>계산서일자</td>
                    <td width=80 rowspan="2" class='title'>수금일자</td>
                    <td width=70 rowspan="2" class='title'>연체일수</td>
                    <td width=70 rowspan="2" class='title'>영업담당자</td>
                </tr>
                <tr>
                  <td width=80 class='title'>차량번호</td>
                  <td width=100 class='title'>차명</td>
                  <td width=80 class='title'>대여금액</td>
                  <td width=70 class='title'>탁송금액</td>
                  <td width=90 class='title'>합계</td>
                </tr>
            </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>
	<td class='line' width='500' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>	
                <tr> 
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=60 align='center'><a name="<%=i+1%>"><%=i+1%><%if(ht.get("USE_YN").equals("N")){%>(해약)<%}%></a></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=60 align='center'><a href="javascript:parent.view_memo('<%=ht.get("RENT_S_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=user_id%>')" onMouseOver="window.status=''; return true"><%=ht.get("PAY_ST")%></a></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=100 align='center'><a href="javascript:parent.view_s_rent('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("RENT_S_CD")%>','<%=i%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=100 align='center'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></a></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=ht.get("CAR_NO2")%></span></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=100 align='center'><span title='<%=ht.get("CAR_NM2")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM2")), 7)%></span></td>
                </tr>
                <%	}%>
                <tr> 
                    <td class="title" colspan='6'>합계</td>
                </tr>	
            </table>
        </td>   
	<td class='line' width='930'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=ht.get("CAR_NO")%></span></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=100 align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 7)%></span></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=ht.get("DAYS")%>일<%=ht.get("HOUR")%>시간</td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='right'><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원</td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=70 align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%>원</td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=90 align='right'><%=Util.parseDecimal(String.valueOf(ht.get("RENT_TOT_AMT")))%>원</td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=60 align='center'><%=ht.get("TM")%>회</td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=80 align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%></td>					
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=70 align='right'><%=ht.get("DLY_DAYS")%>일</td>
                    <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width=70 align='center'><%=ht.get("USER_NM")%></td>
                </tr>
                <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("FEE_AMT")));
				total_amt2 	= total_amt2 + Long.parseLong(String.valueOf(ht.get("CONS_AMT")));
				total_amt3 	= total_amt3 + Long.parseLong(String.valueOf(ht.get("RENT_TOT_AMT")));
		 	}%>
                <tr> 
                    <td class="title" colspan='3'>&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%>원&nbsp;</td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>원&nbsp;</td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%>원&nbsp;</td>			
                    <td class="title" colspan='6'>&nbsp;</td>			
                </tr>
            </table>
	</td>
    </tr>
    <%}else{%>                     
    <tr>
	    <td class='line' width='500' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='930'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		        <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
    <%}%>    
</table>
</form>
</body>
</html>
