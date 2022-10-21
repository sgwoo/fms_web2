<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String vid[] 	= request.getParameterValues("ch_cd");
	String reqseq 	= "";
	
	int vid_size = vid.length;
	
	PayMngDatabase 		pm_db = PayMngDatabase.getInstance();
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//등록하기
function save(){
	fm = document.form1;
	
	var file0 = document.querySelector('#image-cropper0>input[type=file]');
	
	if(fm.reg_type[0].checked == true){ 			//개별
		
	}else{	//일괄		
		<%for(int i=1;i < vid_size;i++){%>	
			var file<%=i%> = document.querySelector('#image-cropper<%=i%>>input[type=file]');
			file<%=i%>.files = file0.files;
		<%	}%>
	}
	    
	if(!confirm("해당 파일을 등록하시겠습니까?"))	return;	
    fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.PAY%>";
	fm.submit();
}


function cng_input(){
	var fm = document.form1;		
	if(fm.reg_type[0].checked == true){ 			//개별
		<%for(int i=1;i < vid_size;i++){%>	
		tr_file<%=i%>.style.display	= '';
		<%	}%>
	}else{											//일괄
		<%for(int i=1;i < vid_size;i++){%>	
		tr_file<%=i%>.style.display	= 'none';
		<%	}%>
	}
}	
	
//-->
</script>
</head>

<body leftmargin="15">
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>      
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='<%=from_page%>'>  


  <table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 출금관리 > <span class=style5>
						출금원장수정</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td>▣ 출금증빙서류 일괄등록</td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td class=title>구분</td>
                <td>&nbsp;
                	<input type="radio" name="reg_type" value="1" onClick="javascript:cng_input()" checked>
        			    출금 선택분 개별 파일 한번에 등록
        			&nbsp;&nbsp;    
        		    <input type="radio" name="reg_type" value="2" onClick="javascript:cng_input()">
        		    	출금 선택분 한파일을 동일 등록 
				</td>                
          </tr>  
              <tr>
      <td class=h colspan='2'></td>
    </tr>
          <tr>
            <td width="30%" class=title>지출처</td>
            <td width="70%" class=title>스캔파일</td>
          </tr>  
          <%	for(int i=0;i < 1;i++){
		          	reqseq = vid[i];
		          	//출금원장
		        	PayMngBean pay 	= pm_db.getPay(reqseq);
          %>
          <tr>
            	<td align="center"><%=pay.getOff_nm()%></td>
                <td>&nbsp;
		        	<dlv id="image-cropper<%=i%>">
			    		<input type="file" name="file" size="100" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=reqseq%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.PAY%>'>
                	</dlv>                  
				</td>                
          </tr>
          <%	}%>      	  
          <%	for(int i=1;i < vid_size;i++){
		          	reqseq = vid[i];
		          	//출금원장
		        	PayMngBean pay 	= pm_db.getPay(reqseq);
		  %>
          <tr id=tr_file<%=i%> style="display:''">            	
            	<td align="center"><%=pay.getOff_nm()%></td>
                <td>&nbsp;
		        	<dlv id="image-cropper<%=i%>">
			    		<input type="file" name="file" size="100" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=reqseq%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.PAY%>'>
                	</dlv>                   
				</td>                
          </tr> 
          <%	}%>     	  
		</table>
	  </td>
	</tr> 	
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 				
    <tr>
	    <td align='center'>	   
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;&nbsp;	   
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
  </table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

