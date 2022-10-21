<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	Vector vt = new Vector();
	
	if(!gubun2.equals("") || !t_wd.equals("")){
		vt = ec_db.getBusAnalysisRentList(s_kd, t_wd, s_dt, e_dt, gubun1, gubun2);
	}
	int cont_size = vt.size();
	
	int count = 0;
%>

<html lang='ko'>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
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
<table border="0" cellspacing="0" cellpadding="0" width='1100'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='390' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='40' class='title'>연번</td>
                    <td width='120' class='title'>계약번호</td>
                    <td width='80' class='title'>계약일</td>
                    <td width="150" class='title'>고객</td>
                </tr>
            </table>
    	</td>
	<td class='line' width='710'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	<tr>
        	    <td width="150" class='title'>차종</td>
        	    <td width="70" class='title'>차량구분</td>
        	    <td width="70" class='title'>계약구분</td>
        	    <td width="70" class='title'>용도구분</td>		  
        	    <td width="70" class='title'>관리구분</td>		  
       	            <td width='80' class='title'>최초영업자</td>
        	    <td width='200' class='title'>시장상황-계약이유</td>        	    
       		</tr>
            </table>
	 </td>
    </tr>
    <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='390' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
				
				if(String.valueOf(ht.get("CLIENT_ID")).equals("000228")) continue;
				if(String.valueOf(ht.get("USE_YN")).equals("N")) continue;
				
    				count++;
    		%>
                <tr> 
                    <td <%=td_color%> width='40' align='center'><%=count%></td>
                    <td <%=td_color%> width='120' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>')" onMouseOver="window.status=''; return true" title='계약상세내역'><%=ht.get("RENT_L_CD")%></a></td>
                    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></td>
                </tr>
                <%	}%>
            </table>
	</td>
	<td class='line' width='710'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
				
				if(String.valueOf(ht.get("CLIENT_ID")).equals("000228")) continue;
				if(String.valueOf(ht.get("USE_YN")).equals("N")) continue;
		%>
        	<tr>
        	    <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("CAR_NAME")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NAME")), 12)%></span></td>        	    
        	    <td <%=td_color%> width='70' align='center'><%=ht.get("CAR_GU")%></td>
        	    <td <%=td_color%> width='70' align='center'><%=ht.get("RENT_ST")%></td>
        	    <td <%=td_color%> width='70' align='center'><%=ht.get("CAR_ST")%></td>        	    
        	    <td <%=td_color%> width='70' align='center'><%=ht.get("RENT_WAY")%></td>	        	    
       		    <td <%=td_color%> width='80' align='center'><%=ht.get("USER_NM")%></td>
        	    <td <%=td_color%> width='200' align='left'>&nbsp;<span title='<%=ht.get("BUS_CAU")%>'><%=AddUtil.subData(String.valueOf(ht.get("BUS_CAU")), 17)%></span></td>
       		</tr>
                <%	}%>
	    </table>
	</td>
    </tr>	
    <%}else{%>
    <tr>		
        <td class='line' width='390' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(gubun2.equals("") && t_wd.equals("")){%>최초영업자 혹은 검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	</td>
	<td class='line' width='710'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		    <td>&nbsp;</td>
		</tr>
  	        </table>
	</td>
    </tr>
    <%}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

