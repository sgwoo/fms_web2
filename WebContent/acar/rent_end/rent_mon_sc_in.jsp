<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");	
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	
	
	Vector conts = rs_db.getRentEndList_New(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, AddUtil.parseInt(s_year), s_kd, t_wd, sort_gubun, asc);
	int cont_size = conts.size();
	
	long total_amt1 = 0;
	long total_amt2 = 0;
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}		
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='1750'>
	<tr><td class=line2 colspan="2"></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='420' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='40' class='title'>연번</td>
                    <td width='40' class='title'>상태</td>
                    <td width='70' class='title'>고객구분</td>
                    <td width='70' class='title'>계약자</td>
                    <td width='120' class='title'>상호</td>
                    <td width='80' class='title'>차량번호</td>		  
                </tr>
            </table>
	    </td>
	    <td class='line' width='1330'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
                            <td width='200' class='title'>차명</td>   
                            <td width='80' class='title'>최초등록일</td>                 
                            <td width='60' class='title'>주행거리</td>
        		    <td width='80' class='title'>계약일자</td>
        		    <td width='70' class='title'>정상대여료</td>
        		    <td width='70' class='title'>D/C</td>
        		    <td width='70' class='title'>사용일수</td>
        		    <td width='120' class='title'>배차(예정)일시</td>
        		    <td width='120' class='title'>반차(예정)일시</td>		          		    
        		    <td width='80' class='title'>정산일자</td>
        		    <td width='200' class='title'>메모</td>
        		    <td width='40' class='title'>지점</td>
        		    <td width='70' class='title'>최초영업자</td>
        		    <td width='70' class='title'>관리담당자</td>
        		</tr>
	        </table>
	    </td>
    </tr>
<%	if(cont_size > 0){	%>  
    <tr>
	    <td class='line' width='420' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>	
                <tr> 
                    <td width='40' align='center'><%=i+1%></td>
                    <td width='40' align='center'><a href="javascript:parent.view_scan('<%=reserv.get("CAR_MNG_ID")%>', '<%=reserv.get("RENT_S_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><%=reserv.get("USE_ST")%></a></td>
                    <td width='70' align='center'><font color="#0080C0"><b><%=reserv.get("CLIENT_ST")%></b></font></td>		  
                    <td width='70' align='center'><span title='<%=reserv.get("CUST_NM")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("CUST_NM")), 8)%></span></td>
                    <td width='120'>&nbsp;<font color="#808080"><span title='<%=reserv.get("FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("FIRM_NM")), 15)%></span></font></td>
                    <td width='80' align='center'><a href="javascript:parent.view_cont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_ST")%>','<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=reserv.get("CAR_NO")%></a></td>
                </tr>
        <%	}%>
                <tr>                     
		    <td class="title" colspan='6'>&nbsp;</td>
                </tr>		        
            </table>
	    </td>
	    <td class='line' width='1330'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(reserv.get("INV_AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(reserv.get("DC_AMT")));%>			
                <tr>
                    <td width='200'>&nbsp;<span title='<%=reserv.get("CAR_NM")%> <%=reserv.get("CAR_NAME")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("CAR_NM"))+" "+String.valueOf(reserv.get("CAR_NAME")), 25)%></span></td>		                    
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                    <td width='60' align="right"><%=Util.parseDecimal(String.valueOf(reserv.get("RUN_KM")))%></td>					
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("RENT_DT")))%></td>
                    <td width='70' align="right"><%=Util.parseDecimal(String.valueOf(reserv.get("INV_AMT")))%></td>					
                    <td width='70' align="right"><%=Util.parseDecimal(String.valueOf(reserv.get("DC_AMT")))%></td>					
                    <td width='70' align='center'><%if(String.valueOf(reserv.get("RENT_ST")).equals("월렌트")){%><%=reserv.get("TOT_MONTHS")%>개월<%=reserv.get("TOT_DAYS")%>일<%}else{%><%=reserv.get("USE_DAY")%>일<%}%></td>
                    <td width='120' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT")))%><%if(String.valueOf(reserv.get("DELI_DT")).equals("")){%><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_PLAN_DT")))%><%}%></td>
                    <td width='120' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%><%if(String.valueOf(reserv.get("RET_DT")).equals("")){%><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_PLAN_DT")))%><%}%></td>		  
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("SETT_DT")))%></td>
                    <td width='200' align="center"><span title='<%=reserv.get("ETC")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("ETC")), 25)%></span></td>
                    <td width='40' align="center"><%=reserv.get("BRCH_ID")%></td>
                    <td width='70' align="center"><%=reserv.get("BUS_NM")%></td>
                    <td width='70' align="center"><%=reserv.get("MNG_NM")%></td>
                </tr>
		<%	}%>
                <tr>                     
		    <td class="title" colspan='4'>합계</td>
		    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
		    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td class="title" colspan='8'>&nbsp;</td>
                </tr>		
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='420' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1330'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        		    <td>&nbsp;</td>
        		</tr>
		    </table>
		</td>
    </tr>
<%	}	%>
</table>
</body>
</html>
