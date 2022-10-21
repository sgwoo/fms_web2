<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*, acar.forfeit_mng.*,java.net.URLEncoder"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	
	Vector vt = fdb.getFineOcrList(s_kd, t_wd, gubun1, st_dt, end_dt, gubun2);
	int vt_size = vt.size();
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language='javascript'>
</script>
</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/consignment_new/cons_req_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='req_dt' value='<%=AddUtil.getDate()%>'>    
  

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 640px;">
					<div style="width: 640px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							   <td width='8%' class='title title_border' style='height:45'>연번</td>
							   <td width='10%' class='title title_border'></td>
							   <td width='10%' class='title title_border'></td>
							   <td width='10%' class='title title_border'>파일</td>
						       <td width='20%' class='title title_border'>구분</td>
						       <td width='15%' class='title title_border'>차량번호</td>				  
							   <td width='24%' class='title title_border'>청구기관</td>
							</tr>
						</table>
					</div>
				</td>
				<td style="width: 2370px;">
					<div style="width: 2370px;">
						<table class="inner_top_table table_layout" style="height: 60px;">
					  	   <colgroup>
				       		  <col  width='2%'>
				       		  <col  width='2%'>
				       		  <col  width='4%'>
				       		  <col  width='3%'>		       		  
							  <col  width='1%'>
							  <col  width='2%'>		       		  
							  <col  width='2%'>
			       			</colgroup>
			       		       		       				       		
		       				<tr>
					          <td width="2%" class='title title_border'>납부고지서번호</td>
					          <td width="2%" class='title title_border'>위반일시</td>				  
							  <td width='4%' class='title title_border'>위반장소</td>				  									
							  <td width='3%' class='title title_border'>위반내용</td>
							  <td width='1%' class='title title_border'>납부금액</td>
							  <td width='2%' class='title title_border'>의견진술기한</td>				  
							  <td width='2%' class='title title_border'>납부기한</td>
							  <td width='1%' class='title title_border'>등록일시</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb" >
			<tr>
				<td style="width: 640px;">
					<div style="width: 640px;">
						<table class="inner_top_table left_fix">	
			<%	if(vt_size > 0)	{%>
			<%		for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						%>
							<tr style="height: 25px;"> 
								<td  width='8%' class='center content_border'><%=i+1%></td>
								<td  width='8%' class='center content_border' style="display:none;"><%=ht.get("SEQ")%></td>
								<td  width='8%' class='center content_border' style="display:none;"><%=ht.get("FILE_NAME")%></td>
								<td  width='8%' class='center content_border' style="display:none;"><%=ht.get("SAVE_FOLDER")%></td>
								<td  width='10%' class='center content_border'><span><a href="javascript:parent.fine_reg('<%=String.valueOf(ht.get("PAID_NO"))%>', '<%=String.valueOf(ht.get("CAR_NO"))%>','<%=gubun1%>','<%=st_dt%>','<%=end_dt%>', '<%=ht.get("SEQ")%>','<%=ht.get("FILE_NAME")%>','<%=ht.get("SAVE_FOLDER")%>')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a></span></td>
								<td  width='10%' class='center content_border'><input class="button btn-submit" type="button" value="미등록" onclick="notReg('<%=gubun1%>','<%=st_dt%>', '<%=end_dt%>', '<%=s_kd%>', '<%=t_wd%>','<%=ht.get("SEQ")%>','<%=ht.get("PAID_NO")%>','<%=ht.get("VIO_DT")%>','<%=ht.get("CAR_NO")%>')" style="width: 39; height: 20; padding:0px; margin:0px;"></td>
								<td  width='10%' class='center content_border'><input class="button btn-submit" type="button" value="파일" onclick="fileDown('<%=URLEncoder.encode(String.valueOf(ht.get("FILE_NAME")), "EUC-KR")%>')" style="width: 39; height: 20; padding:0px; margin:0px;"></td>
								<td  width='20%' class='center content_border'><%=ht.get("GUBUN")%></td>					
								<td  width='15%' class='center content_border'><%=ht.get("CAR_NO")%></td>					
								<td  width='24%' class='center content_border'><%=ht.get("GOV_NM")%></td>
							</tr>
			  			  <%		}%>
					 <%} else  {%>  
						   	<tr>
						        <td class='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
					 <%}	%>
					     </table>
					  </div>		
					</td>
					
		 			<td style="width: 2370px;">	
		 			  <div style="width: 2370px;">
					    <table class="inner_top_table table_layout">			
		    	     
			<%	if(vt_size > 0)	{%>
				
			<%		for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
					
						%>
							<tr style="height: 25px;"> 				
								<td  width='2%' class='center content_border'><span title='<%=ht.get("PAID_NO")%>'><%=Util.subData(String.valueOf(ht.get("PAID_NO")), 25)%></span></td>
								<td  width='2%' class='center content_border'><span title='<%=ht.get("VIO_DT")%>'><%=Util.subData(String.valueOf(ht.get("VIO_DT")), 20)%></span></td>
								<td  width='4%' class='center content_border'><span title='<%=ht.get("VIO_PLA")%>'><%=Util.subData(String.valueOf(ht.get("VIO_PLA")), 40)%></span></td>
								<td  width='3%' class='center content_border'><span title='<%=ht.get("VIO_CONT")%>'><%=Util.subData(String.valueOf(ht.get("VIO_CONT")), 20)%></span></td>
								<td  width='1%' class='center content_border'><span title='<%=ht.get("PAID_AMT")%>'><%=Util.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%></span></td>
								<td  width='2%' class='center content_border'><span title='<%=ht.get("OBJ_END_DT")%>'><%=Util.subData(String.valueOf(ht.get("OBJ_END_DT")), 25)%></span></td>
								<td  width='2%' class='center content_border'><span title='<%=ht.get("PAID_END_DT")%>'><%=Util.subData(String.valueOf(ht.get("PAID_END_DT")), 25)%></span></td>
								<td  width='1%' class='center content_border'><span title='<%=ht.get("REG_DT")%>'><%=String.valueOf(ht.get("REG_DT")).substring(0,19)%></span></td>
							</tr>
			<%			
					}%>
			<%} else  {%>  
					       <tr>
						        <td  colspan="23" class='center content_border'>&nbsp;</td>
						   </tr>	              
			   <%}	%>
				          </table>
				     </div>
				 </td>
   			</tr>
		</table>
	</div>
</div>		    
</form>	            

<script language='javascript'>
// <!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
	function notReg(gubun1, st_dt, end_dt, s_kd, t_wd, seq, paid_no, vio_dt, car_no) {
		var fm = document.form1;
		
		if(confirm(car_no+"번 차량 과태료를 미등록 처리하시겠습니까?")) {
 			fm.action = "fine_ocr_notReg_i_a.jsp?gubun1="+gubun1+"&st_dt="+st_dt+"&end_dt"+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&seq="+seq+"&temp_paid_no="+paid_no+"&temp_vio_dt="+vio_dt+"";
			fm.submit();
		}
	}
	
	function fileDown(file_name) {
		var now = new Date();
		var year = now.getFullYear();
		var imgSrc = "https://ocr.amazoncar.co.kr:8443/fine_mng/"+year+"/"+file_name;
		
		var image = new Image();
		image.crossOrigin = "anonymous";
		image.src = imgSrc;
		var fileName = file_name;
		image.onload = function() {
		  var canvas = document.createElement('canvas');
		  canvas.width = this.width;
		  canvas.height = this.height;
		  canvas.getContext('2d').drawImage(this, 0, 0);
		  if (typeof window.navigator.msSaveBlob !== 'undefined') {
		    window.navigator.msSaveBlob(dataURLtoBlob(canvas.toDataURL()), fileName);
		  } else {
		    var link = document.createElement('a');
		    link.href = canvas.toDataURL();
		    link.download = fileName;
		    link.click();
		  }
		};
	  }
	
	function dataURLtoBlob(dataurl) {
		  var arr = dataurl.split(','),
		    mime = arr[0].match(/:(.*?);/)[1],
		    bstr = atob(arr[1]),
		    n = bstr.length,
		    u8arr = new Uint8Array(n);
		  while (n--) {
		    u8arr[n] = bstr.charCodeAt(n);
		  }
		  return new Blob([u8arr], {
		    type: mime
		  });
		}

</script>
</body>
</html>
