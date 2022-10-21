<%-- <%@ page language="java" contentType="text/html;charset=euc-kr" %> --%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
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
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";

%>
<html>
<head><title>FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
$(document).ready(function() {
	
	$('#upload-select-fake').bind('click', function() {
		removefile();
		$('#upload-select').trigger('click');
	});
	
	$('#upload-select').change(function() {
		 var list = '';
         fileIdx = 0;
         for (var i = 0; i < this.files.length; i++) {
             fileIdx += 1;
             list += fileIdx + '. ' + this.files[i].name + '\n';
         }
         //파일리스트
         $('#upload-list pre').append(list);
         var type= $('#type').val();
         var ins_com= "E"+$('#ins_com').val();
         for (var i = 0; i < this.files.length; i++) {
	         var file = this.files[i];
	         var tokens = file.name.split('.');
	         tokens.pop();
	         var content_seq = tokens.join();
	         var file_name = this.files[i].name;
	     	 var file_size = this.files[i].size;
	         var file_type = this.files[i].type;
	         
	         var tr =
	             '<tr><td>' +
	             '' +
	             '<input type="hidden" class="content" value="'+ content_seq +'">' +
	             '<input type="hidden" name="content_seq" class="content_seq" value="'+ins_com+""+content_seq.replace("_","") +"_"+type +'">' +
	             '<input type="hidden" name="file_name" value="'+ file_name +'">' +
	             '<input type="hidden" name="file_size" value="'+ file_size +'">' +
	             '<input type="hidden" name="file_type" value="'+ file_type +'">' +
	             '</td></tr>';
	         //파일 정보    
	         $('#file-upload-form').append(tr);
         }
         
	     	var real= $('#upload-select');
	    	var cloned = real.clone(true);
	    // 	real.hide();
	    	cloned.insertAfter(real);
	    	real.appendTo('#form2');
         
         //file 
         //$('#form2').append($('#upload-select').clone());
      
         //var pevFileNames = $("#list").jqGrid("getCol", "fileName");
         
         /* for(var i =0; i < pevFileNames.length; i++){
             $('#form2').append('<input type="hidden" name="pevFileNames" id="pevFileNames" value="'+pevFileNames[i]+'">');
         }
          */
		});
	
		$('#upload-button-fake').bind('click', function() {
			if(!confirm("해당 파일을 등록하시겠습니까?")) return;
			var refresh=false;
			if(validation()){
				$("#form2").attr("action", "https://fms3.amazoncar.co.kr/fms2/attach/multifileupload.jsp?contentCode=INSUR");//실제사용
				//$("#form2").attr("action", "/fms2/attach/multifileupload.jsp?contentCode=INSUR"); //테스트용
				$("#form2").attr("target","_blank");
				$("#form2").serialize();
				$("#form2").submit();
				refresh=true;	
			}
			if(refresh){
				setTimeout(function() {
					parent.document.location.reload();// 프레임새로고침
				}, 2000);
			}
		});
		
		$("#type").change(function(){
		   if($(".content_seq").val()!=undefined){
			   $(".content_seq").val($(".content").val()+"_"+$(this).val());
			   
		   }
		});
		$("#ins_com").change(function(){
		   if($(".content_seq").val()!=undefined){
			   $(".content_seq").val("E"+$(this).val()+""+$(".content").val());
			   
		   }
		});
	});
	
	//리스트 삭제
	function removefile(){
		$('#form2').children('#upload-select').remove();
		//$('#form1').children('#pevFileNames').remove();
		$('#file-upload-form').find('tr').remove();
		$('#upload-list').children('pre').empty();
	}
	
	//validation
	function validation(){
		var check = false;
		if($('#type').val() == ''){
			alert("구분을 선택해주세요");
		}else if($('#file-upload-form').find('tr').html() == undefined){
			alert("파일을 등록해주세요");
		}else{
			 check = true;
		}  
		return check;
	}


	//요청
	function select_ins_com(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var act_ment="";
		var chk_value="";
		var checkCnt=-1;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				checkCnt++;
				if(ck.checked == true){
					var fileName = $('#iframe1').contents().find('#table1').find('tr').eq(checkCnt).find('#fileName').html();
					var ext  = fileName.split('.').pop().toLowerCase();
					if(ext != 'pdf' ){
						alert("PDF 파일만 가능합니다");
						return false;
					}
					idnum=ck.value;
					cnt++;
				}
			}
		}	
		if(cnt == 0){
		 	alert("차량을 선택하세요.");
			return;
		}	
		
		fm.size.value = document.form1.size.value;
		
		act_ment="일괄인쇄";
				
		if(confirm(act_ment+' 하시겠습니까?')){
			 window.open("" ,"form1", 
		       "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
			
			//fm.action = "ins_com_file_print.jsp";
			fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/ins_com_file_print.jsp";
			//fm.target = "_blank";
			fm.target = "form1";
			fm.method="post";
			fm.submit();	
		}
	}				

</script>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post' >
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_file_frame.jsp'>
  <input type='hidden' name='reg_code' value=''>
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='contentCode' value='INSUR'>
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
  
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" class="button btn-submit" value="일괄인쇄" onclick="select_ins_com()"/>
		
		<!--파일 업로드  -->
		<div class="search-area" style="display: inline-block;margin-left:100px;">
			<select id="ins_com" name="ins_com" class="select" style="width:120px;">
				<option value=''>보험사</option>
				<option value='0038'>렌터카공제조합</option>
				<option value='0008'>DB손해보험</option>
				<option value='0007'>삼성화재</option>
			</select>
			<select id="type" name="type" class="select" style="width:70px;">
				<option value=''>구분</option>
				<option value='2'>갱신</option>
				<option value='3'>배서</option>
				<option value='4'>해지</option>
			</select>
		    <input type="button" id="upload-select-fake" class="button" value="파일 선택"/>
		    <input type="button" id="upload-button-fake" class="button btn-submit" value="업로드"/>
		    <input style="display: none;" id="upload-select" type="file" name="files[]" multiple>
		</div>
		<div style="margin-left:20px;" id="upload-list"><pre style="font-size: 10.5pt;display: inline-block;"></pre></div>
		
	   	  	
	  </td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe id="iframe1" src="ins_com_file2_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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
		<table id="file-upload-form" style="display: block;"></table>
	</div>
</form>
</body>
</html>
