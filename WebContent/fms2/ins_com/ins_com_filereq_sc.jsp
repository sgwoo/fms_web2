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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//��Ȳ ���μ���ŭ ���� ���������� ������
	
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
	         	//�ش� ������ �ִ��� 	                   
	            if(insConNo == tokens[0]){
					var insCount = 0;
					//�ΰ��� �ִ��� Ȯ��
					for(var k=1; k<=listLength; k++){
						var insConNo2 = $('#inner').contents().find('#ins_con_no'+k).html(); //���ǹ�ȣ
						if(insConNo2 == tokens[0]) insCount++;
					}
					 //�ΰ� �̻��̸�
					 if(insCount>1){
					 	validation = 1;
					 }else{
					 	fileIdx += 1;
					 	list += fileIdx + '. ' + this.files[i].name + '\n';	
					 }
					 
	            }else{
                 	//validation = 1;
                 	
                }
	         	
	        	//�ߺ������ϰ��(���ǹ�ȣ_������_������)
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
			alert("���� ��û�ǿ� ���ǹ�ȣ�� ���ų�\n\n���� ��û�ǿ� 2�� �̻��� ���ǹ�ȣ�� �����մϴ�.\n2�� �̻��ΰ��, �ش� ������ �Ʒ� ���ÿ� ���� �������ֽñ� �ٶ��ϴ�.\n\n����)  P1161712297290_20171226_20181226\n        (���ǹ�ȣ_���������_���踶����)");
		}
		
        //���ϸ���Ʈ
        $('#upload-list pre').append(list);
        
        for (var i = 0; i < this.files.length; i++) {
	        var file = this.files[i];
	        var tokens = file.name.split('.');
	        tokens.pop();
	         
	        var listLength = $('#inner').contents().find('#listtable tr').length;
	        for (var j = 0; j < listLength; j++) {
				var insConNo = $('#inner').contents().find('#ins_con_no'+j).html(); //���ǹ�ȣ
             	
	        	var insStartDt = $('#inner').contents().find('#ins_start_dt'+j).html();
            	var insExpDt = $('#inner').contents().find('#ins_exp_dt'+j).html();
            	var reg_id = $('#inner').contents().find('#reg_id'+j).val();
            	var car_no = $('#inner').contents().find('#car_no'+j).val();

            	var checkFile = tokens[0]; 
            	//�ش� ������ �ִ���
            	
                if (insConNo == checkFile) {
                   	var insCount = 0;
                   	//�ΰ��� �ִ��� Ȯ��
                   	for (var k = 1; k <= listLength; k++) {
                   		var insConNo2 = $('#inner').contents().find('#ins_con_no'+k).html(); //���ǹ�ȣ
						if(insConNo2 == checkFile) insCount++;
                   	}
                   	//�ΰ� �̻��̸�
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
	                          
                        /*�޼��������������ѹ迭  */
                        regIdArr[msgCnt] = reg_id; 
                        carNoArr[msgCnt] = car_no;  
                        msgCnt++;                   		
                   	}
	         	}
            	
              	//�ߺ������ϰ��(���ǹ�ȣ_������_������)
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
		 	                       
								/*�޼��������������ѹ迭  */
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
			
		if (!confirm("�ش� ������ ����Ͻðڽ��ϱ�?")) return;
	    var refresh=false;
	    if (validation()) {
			$("#form2").attr("action", "https://fms3.amazoncar.co.kr/fms2/attach/multifileupload.jsp?contentCode=INSUR");//�������
		//	 $("#form2").attr("action", "/fms2/attach/multifileupload.jsp?contentCode=INSUR"); //�׽�Ʈ��
			$("#form2").attr("target","_blank");
			$("#form2").submit(); 
			refresh=true;	
		}
		if (refresh) {
			var popUrl = "messageControl.jsp?regIdArr="+regIdArr+"&carNoArr="+carNoArr;
      			var popOption = "width=1, height=1, resizable=no, scrollbars=no, status=no;";    
  				window.open(popUrl,"",popOption);
	    	   
	    	setTimeout(function() {
				parent.document.location.reload();// �����ӻ��ΰ�ħ
			}, 3000);  
		}
		          
	});
		
	var gubun2 = '<%=gubun2%>';
	if (gubun2 == '��û') {
		
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
					
	} else if(gubun2 == '�Ϸ�') {
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
	
//����Ʈ ����
function removefile() {
	$('#form2').children('#upload-select').remove();
	//$('#form2').children('#pevFileNames').remove();
	$('#form2').find('#file-upload-form').find('tbody').remove();
	$('#form2').find('#file-upload-form').find('tr').remove();
	$('#upload-list').children('pre').empty();
	$('#upload-select').val("");
}

//��û
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
	 	alert("������ �����ϼ���.");
		return;
	}	
	
	fm.size.value = document.form1.size.value;
	
	act_ment = "�ϰ��μ�";
			
	if (confirm(act_ment+' �Ͻðڽ��ϱ�?')) {
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
		alert("������ ������ּ���");
	} else {
		check = true;
	}  
	return check;
}

function enroll() {
	var fm = document.form1;
	//if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }
	window.open("about:blank", "SEARCH", "left=100, top=100, width=1260, height=600, scrollbars=yes");
	var fm = document.form1;
	fm.gubun3.value = "";
	fm.action = "search.jsp";
	fm.target = "SEARCH";
	fm.submit();
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
		
		fm.action = "/fms2/insure/select_send_mail_insdoc.jsp";
		//fm.target = "_blank";
		fm.target = "form1";
		fm.method = "post";
		fm.submit();	
	}
}	

//���� �ϰ�����
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
	 	alert("������ �����ϼ���.");
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
				<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>
				 &nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" class="button" id="regbtn" value="���" onclick="enroll()" style="width:60px"/>
				
					<!--���� ���ε�  -->
				<div class="search-area" id="search-area" style="display:inline-block;margin-left:100px;">
				    <input type="button" id="upload-select-fake" class="button" value="���� ����"/>
				    <input type="button" id="upload-button-fake" class="button btn-submit" value="���ε�"/>
				    <input style="display: none;" id="upload-select" type="file" name="files[]" multiple>
				</div>
				
				<input type="button" class="button btn-submit"  id="multiprint" value="�ϰ��μ�" onclick="select_ins_com()"/>
			</div> 
			
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
						<iframe src="ins_com_filereq_sc_in.jsp<%=valus%>" name="inner" id="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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
	<table id="file-upload-form" style="display: '';"></table>
</div>
</form>
</body>
</html>
