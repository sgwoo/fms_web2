<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*, java.util.Properties"%>
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
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
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
	
	$('#upload-select').change(function() {
		 var list = '';
         fileIdx = 0;
         for (var i = 0; i < this.files.length; i++) {
             fileIdx += 1;
             list += fileIdx + '. ' + this.files[i].name + '\n';
         }
         //���ϸ���Ʈ
         $('#upload-list pre').append(list);
         
         for (var i = 0; i < this.files.length; i++) {
	         var file = this.files[i];
	         var tokens = file.name.split('.');
	         tokens.pop();
	         var content_seq = tokens.join(); //������ conent_seq ���� _1 �߰� (����:1, ����:2, �輭:3, ����:4)
	         var file_name = this.files[i].name;
	     	 var file_size = this.files[i].size;
	         var file_type = this.files[i].type;
	         
	         var tr =
	             '<tr><td>' +
	             '' +
	             '<input type="hidden" name="content_seq" value="'+ content_seq +'">' +
	             '<input type="hidden" name="file_name" value="'+ file_name +'">' +
	             '<input type="hidden" name="file_size" value="'+ file_size +'">' +
	             '<input type="hidden" name="file_type" value="'+ file_type +'">' +
	             '</td></tr>';
	         //���� ����    
	         $('#file-upload-form').append(tr);
         }
         
	     	var real= $('#upload-select');
	    	var cloned = real.clone(true);
	    	real.hide();
	    	cloned.insertAfter(real);
	    	real.appendTo('#form2');
         
         //file 
        // $('#form2').append($('#upload-select').clone());
      
         
       /*   for(var i =0; i < pevFileNames.length; i++){
             $('#form2').append('<input type="hidden" name="pevFileNames" id="pevFileNames" value="'+pevFileNames[i]+'">');
         } */
         
		});
	
		$('#upload-button-fake').bind('click', function() {
		
		       if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?")) return;
		       var refresh=false;
		       if(validation()){
		          $("#form2").attr("action", "https://fms3.amazoncar.co.kr/fms2/attach/multifileupload.jsp?contentCode=INSUR");//�������
		         // $("#form2").attr("action", "/fms2/attach/multifileupload.jsp?contentCode=INSUR"); //�׽�Ʈ��
		          $("#form2").attr("target","_blank");
		          $("#form2").submit();
		          refresh=true;	
		       }
		       if(refresh){
		    	   setTimeout(function() {
						parent.document.location.reload();// �����ӻ��ΰ�ħ
					}, 2000);
				}
		          
		   });
});
	
	//����Ʈ ����
	function removefile(){
		$('#form2').children('#upload-select').remove();
		//$('#form2').children('#pevFileNames').remove();
		$('#form2').find('#file-upload-form').find('tr').remove();
		$('#upload-list').children('pre').empty();
	}


	//��û
	function select_ins_com(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var act_ment="";
		var chk_value="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;
				}
			}
		}	
		if(cnt == 0){
		 	alert("������ �����ϼ���.");
			return;
		}	
		
		fm.size.value = document.form1.size.value;
		
		act_ment="�ϰ��μ�";
				
		if(confirm(act_ment+' �Ͻðڽ��ϱ�?')){
			 window.open("" ,"form1", 
		       "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
			
			fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/ins_com_file_print.jsp";
			//fm.target = "_blank";
			fm.target = "form1";
			fm.method="post";
			fm.submit();	
		}
	}
	
	//�ϰ�����
	function delete_ins_com(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var act_ment="";
		var chk_value="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
				}
			}
		}	
		if(cnt == 0){
		 	alert("������ �����ϼ���.");
			return;
		}
		
		if (confirm('�ϰ����� �Ͻðڽ��ϱ�?')) {
			/*  window.open("" ,"form1", 
		       "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); */ 
			
			fm.action = "/fms2/ins_com/delete_ins_com_file.jsp";
			//fm.target = "_blank";
			fm.target = "form1";
			fm.method = "post";
			fm.submit();	
		}
		
		setTimeout(function() {  
			location.reload();
		}, 2000);
	}
	
	//validation
	function validation(){
		var check = false;
		if($('#file-upload-form').find('tr').html() == undefined){
			alert("������ ������ּ���");
		}else{
			 check = true;
		}  
		return check;
	}
	

	//���ø��Ϲ߼�
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
		 	alert("������ �����ϼ���.");
			return;
		}
		
		//fm.target = "_blank";
		/* fm.target = "i_no";
		fm.action = "/fms2/insure/select_send_mail_insdoc.jsp";
		fm.submit();	 */
		
		//�������� ��û�� �뿩�ὺ���� ���̹߼�	
		if ($("input[name=check_scd_fee]").is(":checked") == true) {
			fm.checkScdFee.value = "Y";
		} else {
			fm.checkScdFee.value = "";
		}
		
		fm.size.value = document.form1.size.value;
		act_ment = "������ �߼�";
					
		if (confirm(act_ment+' �Ͻðڽ��ϱ�?')) {
			/*  window.open("" ,"form1", 
		       "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); */ 
			
			fm.action = "/fms2/insure/select_send_mail_insdoc2.jsp";
			//fm.target = "_blank";
			fm.target = "form1";
			fm.method = "post";
			fm.submit();	
		}
	}	
	
	
	function excel_upload(){
		$('#excel-upload-file').trigger('click');
	}
	
	function fileChange(){
		 $('#excel-upload-button2').trigger('click');
	}
	
	
   function submitBtn(){
       	if(confirm("�ش� ������ ����Ͻðڽ��ϱ�?")){
	       	var fm = document.form3;	
			window.open("" ,"form3","toolbar=no, width=500, height=200, directories=no, status=no, scrollorbars=no, resizable=no"); 
			fm.action = "ins_com_file_excel_reg.jsp";
			//fm.target = "_blank";
			fm.target = "form3";
			fm.method="post";
			fm.submit();	
	 /*        $("#form3").attr("action", "ins_com_file_excel_reg.jsp");//�������
	        // $("#form2").attr("action", "/fms2/attach/multifileupload.jsp?contentCode=INSUR"); //�׽�Ʈ��
	        $("#form3").attr("target","_blank");
	        $("#form3").submit(); */
       	}
    } 

</script>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
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
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>
	     
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" class="button btn-submit" value="�ϰ��μ�" onclick="select_ins_com()"/>
	  <%if(nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("�������",user_id)){%>
	  <input type="button" class="button btn-submit" value="�ϰ�����" onclick="delete_ins_com()"/>
		<!--���� ���ε�  -->
		<div class="search-area" style="display: inline-block;margin-left:100px;">
		    <input type="button" id="upload-select-fake" class="button" value="���� ����"/>
		    <input type="button" id="upload-button-fake" class="button btn-submit" value="���ε�"/>
		    <input style="display: none;" id="upload-select" type="file" name="files[]" multiple>
 		</div>
 		<div style="display: inline-block;margin-left:200px;">
		   	<input type="button" class="button" value="����������� ���ε�" onclick="excel_upload()" />
 		</div>
 		<%} %>
		<br>
		<div style="margin-left:120px;"><span style="font-size:9pt;color:red;">�� ������ȣ�� ���� ��, ����Ʈ ��ü ���� �� �ϰ��μ⿡�� CTRL+F�� �ش� ������ȣ�� ã�� �ֽñ� �ٶ��ϴ�.</span></div>
		<div style="margin-left:20px;" id="upload-list"><pre style="font-size: 10.5pt;display: inline-block;"></pre></div>
		
	   	  	
	  </td>
	</tr>
	
	<tr>
		<td>
			<span id="sendmail" style="margin-left:50px;width:;">
			<a href="javascript:select_email();" title='���� ���Ϲ߼��ϱ�'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a> (���ݰ�꼭 �̸��� �����ڿ��� �߼۵�)</span>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<div id="div_scd_fee" style="display: inline-block;">
				<input type="checkbox" name="check_scd_fee" id="check_scd_fee"><label for="check_scd_fee">���ø��� �߼۽� �뿩�ὺ���� ���� �߼�</label>
			</div>
		</td>
	</tr>
	
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="ins_com_file_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>

<!--���Ͼ��ε� ����  -->
<form name="form2" id="form2" action="" method="post" enctype="multipart/form-data">
	<div>
		<table id="file-upload-form" style="display: block;"></table>
	</div>
</form>
<%-- ���� ���ۿ� �� --%>
 <form name='form3' id="form3" action="" method="post" enctype="multipart/form-data"> 
<!--  <form name='form2' id="excel-upload" action="https://fms.amazoncar.co.kr/off_web/ins_com/insuUpdExcel2.do" method="post" enctype="multipart/form-data">  -->
    <input type="file" id="excel-upload-file" name="file" onchange="fileChange()">
    <input id="excel-upload-button2" type="submit" value="���ε�" onClick="submitBtn()" />
</form> 
</body>
</html>
