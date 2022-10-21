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
	String del_yn 	= request.getParameter("del_yn")==null?"":request.getParameter("del_yn");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	height = "590";
	sh_height = 590;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	
	Vector vt = fdb.getFineOcrStatList(s_kd, t_wd, gubun1, st_dt, end_dt, gubun2, del_yn);
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
  <input type='hidden' name='del_yn' value='<%=del_yn%>'>
  <input type="hidden" id="arraySize" name="arraySize" value="" />
  <input type="hidden" id="mIdArray" name="mIdArray" value="" />
  <input type="hidden" id="lCdArray" name="lCdArray" value="" />
  <input type="hidden" id="cIdArray" name="cIdArray" value="" />
  <input type="hidden" id="seqNoArray" name="seqNoArray" value="" />
  <input type="hidden" id="firmNmArray" name="firmNmArray" value="" />
  <input type="hidden" id="emailArray" name="emailArray" value="" />
  <%if(gubun2.equals("N")) {%>
  <div style="margin-bottom: 5px;">
  	<a href="javascript:select_email();" title='선택 메일발송하기'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>
  	<input type="button" class="button btn-submit" value="20개 선택" onclick="check()"/>
  </div>
  <%} %>
<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 640px;">
					<div style="width: 640px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							   <td width="4%" class="title title_border"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
							   <td width='6%' class='title title_border' style='height:45'>연번</td>
							   <td width='4%' class='title title_border'>발송<br>여부</td>
							   <td width='4%' class='title title_border'>발송<br>완료<br>여부</td>
							   <td width='30%' class='title title_border'>이메일</td>
						       <td width='10%' class='title title_border'>차량번호</td>				  
							   <td width='24%' class='title title_border'>청구기관</td>
							</tr>
						</table>
					</div>
				</td>
				<td style="width: 2370px;">
					<div style="width: 1200px;">
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
					          <td width="2%" class='title title_border'>상호</td>
					          <td width="2%" class='title title_border'>위반일시</td>				  
							  <td width='4%' class='title title_border'>위반장소</td>				  									
							  <td width='3%' class='title title_border'>위반내용</td>
							  <td width='1%' class='title title_border'>납부금액</td>
							  <td width='2%' class='title title_border'>의견진술기한</td>				  
							  <td width='2%' class='title title_border'>납부기한</td>
							  <td width='1%' class='title title_border'>등록일자</td>
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
								<input type="hidden" name="rent_mng_id" class="rent_mng_iD" value="<%=ht.get("RENT_MNG_ID")%>">
								<input type="hidden" name="rent_l_cd" class="rent_l_cd" value="<%=ht.get("RENT_L_CD")%>">
								<input type="hidden" name="car_mng_id" class="car_mng_id" value="<%=ht.get("CAR_MNG_ID")%>">
								<input type="hidden" name="seq_no" class="seq_no" value="<%=ht.get("SEQ_NO")%>">
								<input type="hidden" name="firm_nm" class="firm_nm" value="<%=ht.get("FIRM_NM")%>">
								<input type="hidden" name="email" class="email" value="<%=ht.get("EMAIL")%>">
								<td  width='4%' class='center content_border'><input type="checkbox" name="ch_cd" class="ch_cd" value="<%=ht.get("CLIENT_ID")%>"></td>
								<td  width='6%' class='center content_border'><%=i+1%></td>
								<td  width='4%' class='center content_border email_yn'><%=ht.get("EMAIL_YN")%></td>
								<td  width='4%' class='center content_border'><%=ht.get("EMAIL_CMPLT_YN")%></td>
								<td  width='30%' class='center content_border'><%=Util.subData(String.valueOf(ht.get("EMAIL")), 25)%></td>
								<td  width='8%' class='center content_border' style="display:none;"></td>
								<td  width='8%' class='center content_border' style="display:none;"></td>
								<td  width='8%' class='center content_border' style="display:none;"></td>
								<td  width='10%' class='center content_border'><a href="javascript:parent.view_fine('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("SEQ_NO")%>')" onMouseOver="window.status=''; return true"><span title='<%=ht.get("CAR_NO")%>'><%=ht.get("CAR_NO")%></span></a></td>					
								<td  width='24%' class='center content_border' title="<%=ht.get("GOV_NM")%>"><%=Util.subData(String.valueOf(ht.get("GOV_NM")), 12)%></td>
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
		 			  <div style="width: 1200px;">
					    <table class="inner_top_table table_layout">			
		    	     
			<%	if(vt_size > 0)	{%>
				
			<%		for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
					
						%>
							<tr style="height: 25px;"> 				
								<td  width='2%' class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'></span><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></td>
								<td  width='2%' class='center content_border'><span title='<%=ht.get("VIO_DT")%>'></span><%=ht.get("VIO_DT")%></td>
								<td  width='4%' class='center content_border'><span title='<%=ht.get("VIO_PLA")%>'><%=Util.subData(String.valueOf(ht.get("VIO_PLA")), 25)%></span></td>
								<td  width='3%' class='center content_border'><span title='<%=ht.get("VIO_CONT")%>'></span><%=ht.get("VIO_CONT")%></td>
								<td  width='1%' class='center content_border'><span title='<%=ht.get("PAID_AMT")%>'></span><%=ht.get("PAID_AMT")%></td>
								<td  width='2%' class='center content_border'><span title='<%=ht.get("OBJ_END_DT")%>'></span><%=ht.get("OBJ_END_DT")%></td>
								<td  width='2%' class='center content_border'><span title='<%=ht.get("PAID_END_DT")%>'></span><%=ht.get("PAID_END_DT")%></td>
								<td  width='1%' class='center content_border'><span title='<%=ht.get("REG_DT")%>'></span><%=ht.get("REG_DT")%></td>
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
	function notReg(gubun1, st_dt, end_dt, s_kd, t_wd, seq, paid_no, vio_dt, car_no, del_yn) {
		var fm = document.form1;
		
		if(confirm(car_no+"번 차량 과태료를 미등록 처리하시겠습니까?")) {
 			fm.action = "fine_ocr_notReg2_i_a.jsp?gubun1="+gubun1+"&st_dt="+st_dt+"&end_dt"+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&seq="+seq+"&temp_paid_no="+paid_no+"&temp_vio_dt="+vio_dt+"&del_yn="+del_yn+"";
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
	
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		 
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}
	
	function select_email() {
		var size = <%=vt_size%>;
		var arraySize = 0;
		var mIdArray	= "";
		var lCdArray	= "";
		var cIdArray	= "";
		var seqNoArray	= "";
		var firmNmArray = "";
		var emailArray	= "";
		
		var checkedSize = $("input:checkbox[name=ch_cd]:checked").length;
		arraySize = checkedSize;
		
		if(arraySize == 0) {
			alert("발송할 항목을 선택하세요.");
			return;
		}
		
		for(var i=0; i<size; i++) {
			if($(".ch_cd").eq(i).is(":checked") == true) {
				if($(".email").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 이메일 주소가 없습니다. 선택 해제 후 발송하세요. \n 해당 건은 과태료 > 과태료관리 > 등록/수정 화면에서 직접 발송하세요.");
					return;
				} else if($(".email_yn").eq(i).text() == "N") {
					alert((i+1)+"번 째 행의 고객은 이메일 발송 대상이 아닙니다. 선택 해제 후 발송하세요.");
					return;
				}
				if(cIdArray == "") {
					mIdArray	+=  $(".rent_mng_id").eq(i).val(); 
					lCdArray	+=  $(".rent_l_cd").eq(i).val(); 
					cIdArray	+=  $(".car_mng_id").eq(i).val(); 
					seqNoArray	+=  $(".seq_no").eq(i).val();
					firmNmArray	+=  $(".firm_nm").eq(i).val(); 
					emailArray	+=  $(".email").eq(i).val(); 
				} else {
					mIdArray	+= (","+$(".rent_mng_id").eq(i).val());
					lCdArray	+= (","+$(".rent_l_cd").eq(i).val());
					cIdArray	+= (","+$(".car_mng_id").eq(i).val());
					seqNoArray	+= (","+$(".seq_no").eq(i).val());
					firmNmArray	+= (","+$(".firm_nm").eq(i).val());
					emailArray	+= (","+$(".email").eq(i).val());
				}                
			}                     
		}
			 $("#mIdArray").val(mIdArray);
			 $("#lCdArray").val(lCdArray);
			 $("#cIdArray").val(cIdArray);
			 $("#seqNoArray").val(seqNoArray);
			 $("#firmNmArray").val(firmNmArray);
			 $("#emailArray").val(emailArray);
			 $("#arraySize").val(arraySize);
			 
			if(confirm("선택할 항목을 발송하시겠습니까?")) {
				setTimeout(function() {
					fm = document.form1;
					fm.action = './forfeit_nbcr_select_mail_a.jsp';
					fm.submit();
				});
			} else {
				return;
			}
	}
	
	function check() {
		for(var i=0; i<20; i++) {	
			$(".ch_cd").eq(i).prop('checked',true);
		}
	}

</script>
</body>
</html>
