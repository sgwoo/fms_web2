<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, java.util.Properties"%>
<%@ include file="/acar/cookies.jsp"%>
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
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
$(document).ready(function() {
	
	$('#upload-select-fake').bind('click', function() {
		removefile();
		$('#upload-select').trigger('click');
	});
	
	var regIdArr = [];
	var carNoArr = [];
	var msgCnt = 0;
	$('#upload-select').change(function() {
		 var list = '';
         fileIdx = 0;
         for (var i = 0; i < this.files.length; i++) {
         /*     fileIdx += 1;
             list += fileIdx + '. ' + this.files[i].name + '\n'; */
          	var validation = 0;
 			var listLength = $('#inner').contents().find('#listtable tr').length;
 			
	 		for(var j = 0; j < listLength; j++){
	 			var insConNo = $('#inner').contents().find('#ins_con_no'+j).html();
	 			var file = this.files[i];
	            var tokens = file.name.split('.');
	         	var checkBar = tokens[0].match(/_/g);
	         	//해당 파일이 있는지 	                   
	            if(insConNo == tokens[0]){
					var insCount = 0;
					//두개가 있는지 확인
					for(var k=1; k<=listLength; k++){
						var insConNo2 = $('#inner').contents().find('#ins_con_no'+k).html(); //증권번호
						if(insConNo2 == tokens[0]) insCount++;
					}
					 //두개 이상이면
					 if(insCount>1){
					 	validation = 1;
					 }else{
					 	fileIdx += 1;
					 	list += fileIdx + '. ' + this.files[i].name + '\n';	
					 }
					 
	            }else{
                 	//validation = 1;
                 	
                }
	         	
	        	//중복파일일경우(증권번호_시작일_마감일)
				if (checkBar) {
					if (checkBar.length > 1) {
						var tokens2 = tokens[0].split('_');
						if(insConNo == tokens2[0]){
							var insStartDt = $('#inner').contents().find('#ins_start_dt'+j).html();
		                    var insExpDt = $('#inner').contents().find('#ins_exp_dt'+j).html();
		                    if(insStartDt == tokens2[1] && insExpDt == tokens2[2]){
		                    	fileIdx += 1;
								list += fileIdx + '. ' + this.files[i].name + '\n';	
		                    }
						}
					} 	  
				}
	         	
	        }
        }
         
		if (validation == 1) {
			alert("현재 요청건에 증권번호가 없거나\n\n현재 요청건에 2개 이상의 증권번호가 존재합니다.\n2개 이상인경우, 해당 파일은 아래 예시와 같이 변경해주시기 바랍니다.\n\n예시)  P1161712297290_20171226_20181226\n        (증권번호_보험시작일_보험마감일)");
		}
		
        //파일리스트
        $('#upload-list pre').append(list);
        
        for (var i = 0; i < this.files.length; i++) {
	        var file = this.files[i];
	        var tokens = file.name.split('.');
	        tokens.pop();
	         
	        var listLength = $('#inner').contents().find('#listtable tr').length;
	        for (var j = 0; j < listLength; j++) {
				var insConNo = $('#inner').contents().find('#ins_con_no'+j).html(); //증권번호
             	
	        	var insStartDt = $('#inner').contents().find('#ins_start_dt'+j).html();
            	var insExpDt = $('#inner').contents().find('#ins_exp_dt'+j).html();
            	var reg_id = $('#inner').contents().find('#reg_id'+j).val();
            	var car_no = $('#inner').contents().find('#car_no'+j).val();

            	var checkFile = tokens[0]; 
            	//해당 파일이 있는지
            	
                if (insConNo == checkFile) {
                   	var insCount = 0;
                   	//두개가 있는지 확인
                   	for (var k = 1; k <= listLength; k++) {
                   		var insConNo2 = $('#inner').contents().find('#ins_con_no'+k).html(); //증권번호
						if(insConNo2 == checkFile) insCount++;
                   	}
                   	//두개 이상이면
                   	if (insCount>1) {
                   		
                   	} else {
                   		var content_seq = checkFile+"_"+insStartDt+"_"+insExpDt ;
	                    var file_name = this.files[i].name;
						var file_size = this.files[i].size;
	                    var file_type = this.files[i].type;
	                        
	                    var tr = '<tr><td>' + '' +
									'<input type="hidden" name="content" class="content" value="'+ content_seq +'">' +
									'<input type="hidden" name="content_seq"  class="content_seq" value="'+ content_seq +'">' +
									'<input type="hidden" name="file_name" value="'+ file_name +'">' +
									'<input type="hidden" name="file_size" value="'+ file_size +'">' +
									'<input type="hidden" name="file_type" value="'+ file_type +'">' +
									'</td></tr>';
	                             
						$('#file-upload-form').append(tr);
	                          
                        /*메세지를보내기위한배열  */
                        regIdArr[msgCnt] = reg_id; 
                        carNoArr[msgCnt] = car_no;  
                        msgCnt++;                   		
                   	}
	         	}
            	
              	//중복파일일경우(증권번호_시작일_마감일)
             	if (checkFile) var checkBar = checkFile.match(/_/g);
                if (checkBar) {
					if (checkBar.length > 1) {
						if (checkFile) var tokens2 = checkFile.split('_');
						if (insConNo == tokens2[0]) {
							var insStartDt = $('#inner').contents().find('#ins_start_dt'+j).html();
				            var insExpDt = $('#inner').contents().find('#ins_exp_dt'+j).html();
		                    if (insStartDt == tokens2[1] && insExpDt == tokens2[2]) {
		                       var content_seq = checkFile ;
		 	                   var file_name = this.files[i].name;
		 	                   var file_size = this.files[i].size;
		 	                   var file_type = this.files[i].type;
		 	                   var tr =
		 	                              '<tr><td>' +
		 	                              '' +
		 	                              '<input type="hidden" name="content" class="content" value="'+ content_seq +'">' +
		 	                              '<input type="hidden" name="content_seq"  class="content_seq" value="'+ content_seq +'">' +
		 	                              '<input type="hidden" name="file_name" value="'+ file_name +'">' +
		 	                              '<input type="hidden" name="file_size" value="'+ file_size +'">' +
		 	                              '<input type="hidden" name="file_type" value="'+ file_type +'">' +
		 	                              '</td></tr>';
		 	                             
								$('#file-upload-form').append(tr);
		 	                       
								/*메세지를보내기위한배열  */
								regIdArr[msgCnt] = reg_id; 
								carNoArr[msgCnt] = car_no;  
								msgCnt++;
		                    }
						}
					} 	  
				}	         
	        }
       	}
         
     	var real= $('#upload-select');
    	var cloned = real.clone(true);
    	real.hide();
    	cloned.insertAfter(real);
    	real.appendTo('#form2');
         
		//file 
		// $('#form2').append($('#upload-select').clone());
      
         
       	/* for (var i =0; i < pevFileNames.length; i++) {
             $('#form2').append('<input type="hidden" name="pevFileNames" id="pevFileNames" value="'+pevFileNames[i]+'">');
        } */
         
	});
	
	$('#upload-button-fake').bind('click', function() {
			
		if (!confirm("해당 파일을 등록하시겠습니까?")) return;
	    var refresh=false;
	    if (validation()) {
			$("#form2").attr("action", "https://fms3.amazoncar.co.kr/fms2/attach/multifileupload.jsp?contentCode=INSUR");//실제사용
		//	 $("#form2").attr("action", "/fms2/attach/multifileupload.jsp?contentCode=INSUR"); //테스트용
			$("#form2").attr("target","_blank");
			$("#form2").submit(); 
			refresh=true;	
		}
		if (refresh) {
			var popUrl = "messageControl.jsp?regIdArr="+regIdArr+"&carNoArr="+carNoArr;
      			var popOption = "width=1, height=1, resizable=no, scrollbars=no, status=no;";    
  				window.open(popUrl,"",popOption);
	    	   
	    	setTimeout(function() {
				parent.document.location.reload();// 프레임새로고침
			}, 3000);  
		}
		          
	});
		
	var gubun2 = '<%=gubun2%>';
	if (gubun2 == '요청') {
		
		var con = document.getElementById("multiprint");
	    if (con.style.display=='none') {
	        con.style.display = '';
	    } else {
	        con.style.display = 'none';
	    }

		var con2 = document.getElementById("sendmail");
		if (con2.style.display=='none') {
		    con2.style.display = '';
		} else {
		    con2.style.display = 'none';
		}
		
		var con3 = document.getElementById("div_scd_fee");
		if (con3.style.display=='none') {
		    con3.style.display = '';
		} else {
		    con3.style.display = 'none';
		    document.getElementById("check_scd_fee").checked = false;
		}
					
	} else if(gubun2 == '완료') {
		var con = document.getElementById("regbtn");
	    if (con.style.display=='none') {
	        con.style.display = '';
	    } else {
	        con.style.display = 'none';
	    }
	    
		var con2 = document.getElementById("search-area");
	    if (con2.style.display=='none') {
	        con2.style.display = '';
	    } else {
	        con2.style.display = 'none';
	    }		    		    
	}	
});
	
//리스트 삭제
function removefile() {
	$('#form2').children('#upload-select').remove();
	//$('#form2').children('#pevFileNames').remove();
	$('#form2').find('#file-upload-form').find('tbody').remove();
	$('#form2').find('#file-upload-form').find('tr').remove();
	$('#upload-list').children('pre').empty();
	$('#upload-select').val("");
}

//요청
function select_ins_com() {
	var fm = inner.document.form1;	
	var len = fm.elements.length;
	var cnt = 0;
	var idnum = "";
	var act_ment = "";
	var chk_value = "";
	
	for (var i = 0 ; i < len ; i++) {
		var ck = fm.elements[i];		
		if (ck.name == "ch_cd") {		
			if (ck.checked == true) {
				var ck_val = ck.value.split("/");
				ck.value = ck_val[0];
				cnt++;
			}
		}
	}	
	if(cnt == 0){
	 	alert("차량을 선택하세요.");
		return;
	}	
	
	fm.size.value = document.form1.size.value;
	
	act_ment = "일괄인쇄";
			
	if (confirm(act_ment+' 하시겠습니까?')) {
		window.open("" ,"form1", "toolbar=no, width=800, height=930, directories=no, status=no, scrollorbars=no, resizable=no"); 
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/ins_com_file_print.jsp";
		//fm.target = "_blank";
		fm.target = "form1";
		fm.method = "post";
		fm.submit();	
	}
}			

//validation
function validation() {
	var check = false;
	if ($('#file-upload-form').find('tr').html() == undefined) {
		alert("파일을 등록해주세요");
	} else {
		check = true;
	}  
	return check;
}

function enroll() {
	var fm = document.form1;
	//if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }
	window.open("about:blank", "SEARCH", "left=100, top=100, width=1260, height=600, scrollbars=yes");
	var fm = document.form1;
	fm.gubun3.value = "";
	fm.action = "search.jsp";
	fm.target = "SEARCH";
	fm.submit();
}
	
//선택메일발송
function select_email() {
	var fm = inner.document.form1;
	var len = fm.elements.length;
	var cnt = 0;
	var idnum = "";
	var act_ment = "";
	var chk_value = "";
	
	for (var i = 0 ; i < len ; i++) {
		var ck=fm.elements[i];
		if (ck.name == "ch_cd") {
			if (ck.checked == true) {
				idnum = ck.value;
				cnt++;
			}
		}
	}
	
	if (cnt == 0) {
	 	alert("차량을 선택하세요.");
		return;
	}
	
	//fm.target = "_blank";
	/* fm.target = "i_no";
	fm.action = "/fms2/insure/select_send_mail_insdoc.jsp";
	fm.submit();	 */
	
	//가입증명서 요청시 대여료스케줄 같이발송	
	if ($("input[name=check_scd_fee]").is(":checked") == true) {
		fm.checkScdFee.value = "Y";
	} else {
		fm.checkScdFee.value = "";
	}
	
	fm.size.value = document.form1.size.value;
	act_ment = "메일을 발송";
				
	if (confirm(act_ment+' 하시겠습니까?')) {
		/*  window.open("" ,"form1", 
	       "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); */ 
		
		fm.action = "/fms2/insure/select_send_mail_insdoc.jsp";
		//fm.target = "_blank";
		fm.target = "form1";
		fm.method = "post";
		fm.submit();	
	}
}	

//선택 일괄수정
/* 
function select_update(){
	var fm = inner.document.form1;	
	var len = fm.ch_cd.length;
	var cnt = 0;
	var reg_code="";
	var seq="";
	var etc="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.ch_cd[i];		
			if(ck.checked == true){
				var ck_val = ck.value.split("/");
				ck.value=ck_val[0];
				reg_code= fm.reg_code[i].value;
				seq = fm.seq[i].value;
				etc = fm.etc[i].value;
				
				var popUrl  = 'ins_com_filereq_upd.jsp?&reg_code='+reg_code+'&seq='+seq+'&etc='+etc;
   				window.open(popUrl,"_blank");
				alert();
   				cnt++;
			}
		}
	if (cnt == 0) {
	 	alert("차량을 선택하세요.");
		return;
	}
}
*/
</script>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='andor' value='<%=andor%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
<input type='hidden' name='sort' 	value='<%=sort%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_file_frame.jsp'>
<input type='hidden' name='reg_code' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='contentCode' value='INSUR'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>	     
			<div class="func_area"  style="display:inline-block;width:95%">
				<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
				 &nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" class="button" id="regbtn" value="등록" onclick="enroll()" style="width:60px"/>
				
					<!--파일 업로드  -->
				<div class="search-area" id="search-area" style="display:inline-block;margin-left:100px;">
				    <input type="button" id="upload-select-fake" class="button" value="파일 선택"/>
				    <input type="button" id="upload-button-fake" class="button btn-submit" value="업로드"/>
				    <input style="display: none;" id="upload-select" type="file" name="files[]" multiple>
				</div>
				
				<input type="button" class="button btn-submit"  id="multiprint" value="일괄인쇄" onclick="select_ins_com()"/>
			</div> 
			
			<div style="margin-left:20px;" id="upload-list"><pre style="font-size: 10.5pt;display: inline-block;"></pre></div>	   	  	
	  	</td>
	</tr>
	
	<tr>
		<td>
			<span id="sendmail" style="margin-left:50px;width:;">
			<a href="javascript:select_email();" title='선택 메일발송하기'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a> (세금계산서 이메일 수신자에게 발송됨)</span>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<div id="div_scd_fee" style="display: inline-block;">
				<input type="checkbox" name="check_scd_fee" id="check_scd_fee"><label for="check_scd_fee">선택메일 발송시 대여료스케줄 같이 발송</label>
			</div>
		</td>
	</tr>
	
	<tr>		
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="ins_com_filereq_sc_in.jsp<%=valus%>" name="inner" id="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>

<!--파일업로드 정보  -->
<form name="form2" id="form2" action="" method="post" enctype="multipart/form-data">
<div>
	<table id="file-upload-form" style="display: '';"></table>
</div>
</form>
</body>
</html>
