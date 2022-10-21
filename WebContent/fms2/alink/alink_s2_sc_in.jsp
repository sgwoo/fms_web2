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
	
	Vector vt = ln_db.getAlinkSendLCList(s_kd, t_wd, andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);	
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
	
	
	//계약서 전송  - zip   (압축풀고 진행)
	function file_unzip(zipfile, m_id, l_cd, rent_st, reg_id){
		
		var fm = document.form1;
		var SUMWIN = "";	
	//	var zipfilename=encodeURIComponent(zipfile);	
	
		window.open(SUMWIN, "upfile", "left=50, top=50, width=500, height=400, scrollbars=yes, status=yes");		
			
		fm.target = "upfile";
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileunzip.jsp?ZIPFILENAME="+zipfile+"&m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&reg_id="+reg_id;
		fm.submit();		
		
	}
	
	//계약서 전송  - (해당 파일 바로 up)
	function file_up(zipfile, m_id, l_cd, rent_st, reg_id){
		
		var fm = document.form1;
		var SUMWIN = "";		
		
		window.open(SUMWIN, "upfile", "left=50, top=50, width=500, height=400, scrollbars=yes, status=yes");		
			
		fm.target = "upfile";
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileup.jsp?ZIPFILENAME="+zipfile+"&m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&reg_id="+reg_id;
		fm.submit();		
		
	}
	
	//계약서 전송  - (해당 파일 중 계약서 jpg변경 테스트)
	function file_img(zipfile, m_id, l_cd, rent_st, reg_id){
		
		var fm = document.form1;
		var SUMWIN = "";		
		
		window.open(SUMWIN, "upfile", "left=50, top=50, width=500, height=400, scrollbars=yes, status=yes");		
			
		fm.target = "upfile";
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/filetoimg.jsp?ZIPFILENAME="+zipfile+"&m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&reg_id="+reg_id;
		fm.submit();		
		
	}
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST" >
<table border="0" cellspacing="0" cellpadding="0" width='1830'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='390' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height='100%'>
                <tr> 
                    <td width='80' class='title' style='height:51'>연번</td>
                    <td width='140' class='title'>문서구분</td>
                    <td width='50' class='title'>계약<br>구분</td>
                    <td width='120' class='title'>계약번호</td>
                </tr>
            </table>
    	</td>
	<td class='line' width='1430'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
                <td rowspan="2" width="150" class='title' >상호</td>
                <td colspan="2" class='title'>자동차</td>		
        	    <td colspan="2" class='title'>대여기간</td>
                <td rowspan="2" width='80' class='title'>송신일자</td>
        	    <td rowspan="2" width="60" class='title'>송신자</td>
                <td rowspan="2" width='60' class='title'>처리</td>        	    
                <td rowspan="2" width='120' class='title'>상태</td>
                <td rowspan="2" width='60' class='title'>계약서<br>구분</td>        	    
                <td colspan="2" class='title'>파일</td>		     	    
                    <!-- <td colspan="4" class='title'>스캔여부</td> -->		     	    
        	</tr>
        	<tr>
        	    <td width="150" class='title'>차명</td>
        	    <td width="100" class='title'>차량번호</td>
        	    <td width='80' class='title'>대여개시일</td>
        	    <td width='80' class='title'>대여만료일</td>
        	    <td width='150' class='title'>PDF파일</td>
        	    <td width='100' class='title'>JPG압축파일</td>
        	    <!-- <td width='60' class='title'>계약서앞</td>
        	    <td width='60' class='title'>계약서뒤</td>
        	    <td width='60' class='title'>개인정보</td>
        	    <td width='60' class='title'>출금이체</td> -->
        	</tr>
	     </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>		
        <td class='line' width='390' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N") || String.valueOf(ht.get("DOC_YN_NM")).equals("취소")){ td_color = "class='is'"; }
    		%>
                <tr> 
                    <td <%=td_color%> width='80' align='center' style='height:32' ><%=i+1%><%if(String.valueOf(ht.get("USE_YN")).equals("N")){%>(해지)<%}%></td>
        	    <td <%=td_color%> width='140' align='center'><%=ht.get("DOC_TYPE_NM")%></td>
        	    <td <%=td_color%> width='50' align='center'><%=ht.get("CONT_RENT_ST")%></td>		  
                    <td <%=td_color%> width='120' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>', '<%=ht.get("CAR_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>','<%if(String.valueOf(ht.get("USE_YN")).equals("") && String.valueOf(ht.get("SANCTION_ST")).equals("요청")){%>요청<%}else{%><%}%>')" onMouseOver="window.status=''; return true" title='계약상세내역'></a><%=ht.get("RENT_L_CD")%></td>
                </tr>
        	<%	}%>
            </table>
	</td>
	<td class='line' width='1430'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N") || String.valueOf(ht.get("DOC_YN_NM")).equals("취소")){ td_color = " class=is "; }		
		%>
       		<tr>
                    <td <%=td_color%> width='150' align='center' style='height:32'><span title='<%=ht.get("COMPANY_NAME")%>'><%=AddUtil.subData(String.valueOf(ht.get("COMPANY_NAME")), 9)%></span></td>
        	    <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
        	    <td <%=td_color%> width='100' align='center'><%=ht.get("CAR_NO")%></td>					
       		    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
       		    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
        	    <td <%=td_color%> width='60' align='center'><%=ht.get("ACAR_USER_NM")%></td>        	    
        	    <td <%=td_color%> width='60' align='center'><%=ht.get("DOC_YN_NM")%></td>        	    
                    <td <%=td_color%> width='120' align='center'>
                        <%if(String.valueOf(ht.get("DOC_STAT")).equals("완료")){%>
                            <%=ht.get("DOC_STAT")%>
                        <%}else{%>
                            <a href="javascript:parent.go_edoc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("LINK_TABLE")%>', '<%=ht.get("DOC_TYPE")%>', '<%=ht.get("RENT_ST")%>', '<%=ht.get("IM_SEQ")%>')" onMouseOver="window.status=''; return true" title='문서상태 상세보기'><%=ht.get("DOC_STAT")%></a>
                        <%}%>
                    </td>
        	    	<td <%=td_color%> width='60' align='center'><%=ht.get("DOC_ST_NM")%></td>        	    
                    <td <%=td_color%> width='150' align='center'>
                        <%if(!String.valueOf(ht.get("FILE_PDF")).equals("")){%>
                            <a href="javascript:MM_openBrWindow('<%=AddUtil.replace(String.valueOf(ht.get("FILE_PDF")), "D:/inetpub/wwwroot","")%>','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
                             &nbsp;<input type="button" class="button" id='downfile' value='스캔등록' onclick="javascript:file_up('<%=AddUtil.replace(String.valueOf(ht.get("FILE_PDF")), "D:/inetpub/wwwroot","")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>', '<%=user_id%>')">	  
                             <% if ( user_id.equals("000063") ){ %>
                              <input type="button" class="button" id='imgfile' value='Img' onclick="javascript:file_img('<%=AddUtil.replace(String.valueOf(ht.get("FILE_PDF")), "D:/inetpub/wwwroot","")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>', '<%=user_id%>')">
                              <% } %>  
                        <%}%>
                    </td>        	    
                    <td <%=td_color%> width='100' align='center'>
                        <%if(!String.valueOf(ht.get("FILE_ZIP")).equals("")){%>
                            <a href="javascript:MM_openBrWindow('<%=AddUtil.replace(String.valueOf(ht.get("FILE_ZIP")), "D:/inetpub/wwwroot","")%>','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
                            &nbsp;<input type="button" class="button" id='downfile' value='스캔등록' onclick="javascript:file_unzip('<%=AddUtil.replace(String.valueOf(ht.get("FILE_ZIP")), "D:/inetpub/wwwroot","")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>', '<%=user_id%>')">	  
                            
                       
                        <%}%>
                    </td>        	    
                    <%-- <td <%=td_color%> width='60' align='center'><%=ht.get("FILE_CNT17")%></td>        	    
                    <td <%=td_color%> width='60' align='center'><%=ht.get("FILE_CNT18")%></td>        	    
                    <td <%=td_color%> width='60' align='center'><%=ht.get("FILE_CNT37")%></td>        	    
                    <td <%=td_color%> width='60' align='center'><%=ht.get("FILE_CNT38")%></td> --%>        	    
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
                    <td align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
           </table>
	  </td>
	  <td class='line' width='1430'>			
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

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>

</body>
</html>


