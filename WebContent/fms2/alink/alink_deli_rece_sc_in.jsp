<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = ln_db.getAlinkDeliReceiptList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);	
	int vt_size = vt.size();
%>

<html lang='ko'>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	var popObj = null;


	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
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
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' id='td_title' style='position:relative;'> 
   	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
   	    		<colgroup>
   	    			<col width='4%'>
   	    			<col width='10%'>
   	    			<col width='12%'>
   	    			<col width='18%'>
   	    			<col width='*'>
   	    			<col width='7%'>
   	    			<col width='7%'>
   	    			<col width='5%'>
   	    			<col width='5%'>
   	    			<col width='4%'>
   	    		</colgroup>
            	<tr> 
                	<td class='title' style='height:51'>연번</td>
                    <td class='title'>탁송번호</td>
                    <td class='title'>탁송업체</td>
                    <td class='title'>고객상호</td>
                    <td class='title'>차명</td>		
        	    	<td class='title'>차량번호</td>
                    <td class='title'>등록일자</td>
        	    	<td class='title'>송신자<br>(의뢰자)</td>
                    <td class='title'>상태</td>        	    
                    <td class='title'>PDF</td>
        		</tr>
    <%if(vt_size > 0){%>
 		<%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String td_color = "";
			if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
			
			String prev_cons_no = String.valueOf(ht.get("CONS_NO"));
			String[] cons = prev_cons_no.split("-");
			String cons_no = cons[0];
			String seq = cons[1];
			
			String prev_car_no = String.valueOf(ht.get("CAR_NO"));
			String car_no = "";
			if( prev_car_no.length() > 10 ) {
				car_no = cs_db.getCarNo(cons_no, Integer.parseInt(seq));
			}
			car_no = car_no == "" ? prev_car_no : car_no;
    		%>
	            <tr> 
	                <td <%=td_color%> align='center'><%=i+1%></td>
	    	    	<td <%=td_color%> align='center'><%=ht.get("CONS_NO")%></td>		  
	                <td <%=td_color%> align='center'><%=ht.get("OFF_NM") %></td>
	                <td <%=td_color%> align='center'><%=ht.get("FIRM_NM")%></td>
	                <td <%=td_color%> align='center'><%=ht.get("CAR_NM")%></td>
	                <td <%=td_color%> align='center'><%=car_no%></td>
	                <td <%=td_color%> align='center'><%=AddUtil.ChangeDate(String.valueOf(ht.get("REG_YMD")),"YYYY-MM-DD")%></td>
	                <td <%=td_color%> align='center'><%=ht.get("ACAR_MNG")%></td>
	                <td <%=td_color%> align='center'><%=ht.get("DOC_STAT")%></td>
	                <td <%=td_color%> align='center'><a href="https://fms3.amazoncar.co.kr/<%=String.valueOf(ht.get("CONTENT")).substring(19)%>" target="_blank"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
	            </tr>
       	<%}%>
      		</table>
		</td>
    </tr>	    
    <%}else{%>                         
    <tr>		
        <td class='line' width='100%' id='td_con' colspan="10"> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr> 
                <td align='center'>조회된 데이터가 없습니다</td>
            </tr>
        </table>
		</td>
    </tr>
    <%}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>


