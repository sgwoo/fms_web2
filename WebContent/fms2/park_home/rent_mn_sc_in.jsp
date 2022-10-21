<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*, acar.user_mng.*, acar.parking.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	//팝업윈도우 열기
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"c.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "02");
	
	Vector conts = pk_db.getRentMngList_New(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_kd, t_wd, sort_gubun, asc);
	int cont_size = conts.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width='1780'>
	<tr><td class=line2 colspan="2"></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='360' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='40' class='title'>연번</td>
                    <td width='50' class='title'>출력증</td>
                    <td width='70' class='title'>계약구분</td>
                    <td width='120' class='title'>상호</td>
                    <td width='80' class='title'>차량번호</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1440'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
					<td width='200' class='title'>차명</td>
					<td width='80' class='title'>원인차량번호</td>					
                    <td width='100' class='title'>원인차량차종</td>			
        		    <td width='80' class='title'>계약일자</td>
        		    <td width='150' class='title'>대여시작일</td>
        		    <td width='150' class='title'>대여만료일</td>		  		  
        		    <td width='150' class='title'>배차일시</td>
        		    <td width='150' class='title'>반차예정일시</td>
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
	    <td class='line' width='360' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>	
                <tr> 
                    <td width='40' align='center'><%=i+1%></td>		  
                    <td width='50' align='center'>
						<%if(!String.valueOf(reserv.get("RENT_ST")).equals("예약대기") && !String.valueOf(reserv.get("RENT_ST")).equals("장기대기") ){%>
						<a href="javascript:parent.open_print('<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_print.gif"  align="absmiddle" border="0"></a>         		   
						<%}else{%>
						-
						<%}%>
                    </td>
                    <td width='70' align='center'><font color="#0080C0"><b><%=reserv.get("RENT_ST")%></b></font></td>		  
                    <td width='120'>&nbsp;<font color="#808080"><span title='<%=reserv.get("FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("FIRM_NM")), 17)%></span></font></td>		  
                    <td width='80' align='center'><%=reserv.get("CAR_NO")%></td>
                </tr>
        <%	}%>
            </table>
	    </td>
	    <td class='line' width='1440'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>			
                <tr>
                    <td width='200'>&nbsp;<span title='<%=reserv.get("CAR_NM")%> <%=reserv.get("CAR_NAME")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("CAR_NM"))+" "+String.valueOf(reserv.get("CAR_NAME")), 25)%></span></td>		
                  <td width='80' align='center'><%=reserv.get("D_CAR_NO")%></td>	
                  <td width='100' align='center'>&nbsp;<span title='<%=reserv.get("D_CAR_NM")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("D_CAR_NM")), 12)%></span></td>					  
                  <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("RENT_DT")))%></td>
                  <td width='150' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RENT_START_DT")))%></td>
                  <td width='150' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RENT_END_DT")))%></td>		  
                  <td width='150' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT")))%></td>
                  <td width='150' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_PLAN_DT")))%></td>		  
                  <td width='200'>&nbsp;<span title='<%=reserv.get("ETC")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("ETC")), 25)%></span></td>
                  <td width='40' align='center'><%=reserv.get("BRCH_ID")%></td>
                  <td width='70' align="center"><%=reserv.get("BUS_NM")%></td>		  
                  <td width='70' align="center"><%=reserv.get("MNG_NM")%></td>		  
                </tr>
		<%	}%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='360' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1440'>			
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
