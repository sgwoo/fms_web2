<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?	"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	int count =0;
	
	Vector vt = ln_db.getAlinkSendList(s_kd, t_wd, andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);	
	int vt_size = vt.size();
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
<table border="0" cellspacing="0" cellpadding="0" width='1140'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='340' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='80' class='title' style='height:51'>연번</td>
                    <td width='140' class='title'>구분</td>
                    <td width='120' class='title'>계약번호</td>
                </tr>
            </table>
    	</td>
	<td class='line' width='800'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan="2" width="150" class='title'>상호</td>
                    <td colspan="2" class='title'>자동차</td>		
        	    <td colspan="2" class='title'>대여기간</td>
                    <td rowspan="2" width='80' class='title'>송신일자</td>
        	    <td rowspan="2" width="60" class='title'>송신자</td>
                    <td rowspan="2" width='100' class='title'>상태</td>        	    
        	</tr>
        	<tr>
        	    <td width="150" class='title'>차명</td>
        	    <td width="100" class='title'>차량번호</td>
        	    <td width='80' class='title'>대여개시일</td>
        	    <td width='80' class='title'>대여만료일</td>
        	</tr>
	     </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>		
        <td class='line' width='340' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")){ td_color = "class='is'"; }
    		%>
                <tr> 
                    <td <%=td_color%> width='80' align='center'><%=i+1%><%if(String.valueOf(ht.get("USE_YN")).equals("N")){%>(해지)<%}%></td>
        	    <td <%=td_color%> width='140' align='center'><%=ht.get("DOC_TYPE_NM")%></td>		  
                    <td <%=td_color%> width='120' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>', '<%=ht.get("CAR_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>','<%if(String.valueOf(ht.get("USE_YN")).equals("") && String.valueOf(ht.get("SANCTION_ST")).equals("요청")){%>요청<%}else{%><%}%>')" onMouseOver="window.status=''; return true" title='계약상세내역'></a><%=ht.get("RENT_L_CD")%></td>
                </tr>
        	<%	}%>
            </table>
	</td>
	<td class='line' width='800'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")){ td_color = " class=is "; }		
		%>
       		<tr>
                    <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("COMPANY_NAME")%>'><%=AddUtil.subData(String.valueOf(ht.get("COMPANY_NAME")), 9)%></span></td>
        	    <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
        	    <td <%=td_color%> width='100' align='center'><%=ht.get("CAR_NO")%></td>					
       		    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
       		    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
        	    <td <%=td_color%> width='60' align='center'><%=ht.get("ACAR_USER_NM")%></td>        	    
                    <td <%=td_color%> width='100' align='center'>
                        <%if(String.valueOf(ht.get("DOC_STAT")).equals("완료")){%>
                            <%=ht.get("DOC_STAT")%>
                        <%}else{%>
                        	<%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) < 20190514){ %>
                            	<a href="javascript:parent.go_edoc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("LINK_TABLE")%>', '<%=ht.get("DOC_TYPE")%>', '<%=ht.get("RENT_ST")%>', '<%=ht.get("IM_SEQ")%>')" onMouseOver="window.status=''; return true" title='문서상태 상세보기'><%=ht.get("DOC_STAT")%></a>
                            <%}else{ %>
                            	<%=ht.get("DOC_STAT")%>
                            <%}%>	
                        <%}%>
                    </td>
        	</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	    
    <%}else{%>                         
    <tr>		
        <td class='line' width='340' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	</td>
	<td class='line' width='800'>			
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
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>


