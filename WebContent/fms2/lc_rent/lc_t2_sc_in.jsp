<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = new Vector();
	
	vt = a_db.getContTaecha2StatList(s_kd, t_wd, andor, gubun1, gubun2, gubun3);
	
	int cont_size = vt.size();
%>

<html>
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
<table border="0" cellspacing="0" cellpadding="0" width='1475'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='270' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title' style='height:51'>연번</td>
                    <td width='100' class='title'>계약번호</td>
                    <td width="140" class='title'>고객</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1250'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<tr>
                    <td colspan="4" class='title'>계약</td>
                    <td colspan="2" class='title'>해지</td>
                    <td colspan="7" class='title'>출고지연대차</td>
        	    </tr>
        		<tr>
        		    <td width='70' class='title'>계약구분</td>
        		    <td width='70' class='title'>최초영업자</td>
        		    <td width='80' class='title'>차량번호</td>
        		    <td width="85" class='title'>대여개시일</td>
        		    
        		    <td width='80' class='title'>해지구분</td>
        		    <td width="85" class='title'>해지일자</td>
        		    					        		    
        	        <td width='80' class='title'>차량번호</td>
        	        <td width='200' class='title'>차종</td>
        	        <td width='200' class='title'>상호</td>
        	        <td width='85' class='title'>구분</td>
        	        <td width='85' class='title'>배차일</td>					
        		    <td width="85" class='title'>반차일</td>
        		    <td width="45" class='title'>일수</td>
        		    				
        		</tr>
    	    </table>
	    </td>
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='270' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < cont_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				String td_color = "";
    				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
    				//if(String.valueOf(ht.get("RENT_L_CD")).equals("G121HILE00021")) continue;
    				count++;
    		%>
                <tr> 
                    <td <%=td_color%> width='30' align='center'><%=count%></td>
                    <td <%=td_color%> width='100' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>', '<%=ht.get("CAR_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a>&nbsp;<%if(!String.valueOf(ht.get("USE_YN")).equals("") && (nm_db.getWorkAuthUser("관리자모드",user_id) || nm_db.getWorkAuthUser("차종관리",user_id))){%><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '')" onMouseOver="window.status=''; return true">.</a><%}%></td>
                    <td <%=td_color%> width='140' align='center'><span title='<%=ht.get("R_FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("R_FIRM_NM")), 8)%></span></td>
                </tr>
            <%		}	%>
            </table>
	    </td>
	    <td class='line' width='1250'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";
				//if(String.valueOf(ht.get("RENT_L_CD")).equals("G121HILE00021")) continue;
		%>
        		<tr>
        		    <td <%=td_color%> width='70' align='center'><%=ht.get("CAR_GU")%></td>
        		    <td <%=td_color%> width='70' align='center'><%=ht.get("USER_NM")%></td>
        		    <td <%=td_color%> width='80' align='center'><%=ht.get("R_CAR_NO")%></td>				
        		    <td <%=td_color%> width='85' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
        		    
        		    <td <%=td_color%> width='80' align='center'><%=ht.get("CLS_ST")%></td>				
        		    <td <%=td_color%> width='85' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>
        		    
        		    <td <%=td_color%> width='80' align='center'><%=ht.get("CAR_NO")%></td>
        		    <td <%=td_color%> width='200' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 12)%></span></td>
        		    <td <%=td_color%> width='200' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 12)%></span></td>									
        		    <td <%=td_color%> width='85' align='center'><%=ht.get("USE_ST")%></td>
        		    <td <%=td_color%> width='85' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DELI_DT")))%></td>
        		    <td <%=td_color%> width='85' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RET_DT")))%></td>
        		    <td <%=td_color%> width='45' align='center'><%=ht.get("DAYS")%></td>
        		</tr>
<%		}	%>
          </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='270' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1250'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
  	        </table>
	    </td>
    </tr>
<%	}	%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=count%>';
//-->
</script>
</body>
</html>


