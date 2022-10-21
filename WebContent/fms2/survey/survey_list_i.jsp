<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.call.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="poll_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
	
	
	String poll_id = poll_db.getPollNextId();
%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>fms</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>

<script>
$(function() {
  $( "#start_dt" ).datepicker({
    dateFormat: 'yy-mm-dd',
    prevText: '���� ��',
    nextText: '���� ��',
    monthNames: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��'],
    monthNamesShort: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��'],
    dayNames: ['��','��','ȭ','��','��','��','��'],
    dayNamesShort: ['��','��','ȭ','��','��','��','��'],
    dayNamesMin: ['��','��','ȭ','��','��','��','��'],
    showMonthAfterYear: true,
    yearSuffix: '��'
  });
});
$(function() {
  $( "#end_dt" ).datepicker({
    dateFormat: 'yy-mm-dd',
    prevText: '���� ��',
    nextText: '���� ��',
    monthNames: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��'],
    monthNamesShort: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��'],
    dayNames: ['��','��','ȭ','��','��','��','��'],
    dayNamesShort: ['��','��','ȭ','��','��','��','��'],
    dayNamesMin: ['��','��','ȭ','��','��','��','��'],
    showMonthAfterYear: true,
    yearSuffix: '��'
  });
});

</script>
<script language='javascript'>
<!--
     var cnt = new Array();
     cnt[0] = new Array('����');
     cnt[1] = new Array('����','�ű�','����','����','�縮��','����Ʈ');
     cnt[2] = new Array('����','��ȸ����');
     cnt[3] = new Array('����','���ó��');
   

     function change(plus) {
     var sel=document.form1.poll_st
       /* �ɼǸ޴����� */
       for (i=sel.length-1; i>=0; i--){
         sel.options[i] = null
         }
       /* �ɼǹڽ��߰� */
       for (i=0; i < cnt[plus].length;i++){                     
         sel.options[i] = new Option(cnt[plus][i], cnt[plus][i]);
       }         
     }
//-->
</script>
<!-- �������̺� ���� �κ�, �����߰���ư Ŭ���� �����ϴ� ��ũ��Ʈ -->
<script type="text/javascript">
var rowIndex = 0;

$(document).ready(function(){
 var rowTag = $("#addTbl tbody").html();
 $("#addTbl").data("rowTag", rowTag); 
 //Ű�� rowTag�� ���̺��� �⺻ row ���� Html�±� ����
  
});

function fnAddRow(){
 var rowlen = $("#addTbl tr").length-1;
 //$("#addTbl tbody").append("<tr id='"+rowIndex+"'><td></td><td></td><td></td></tr>");
 
 //alert(rowlen);
 
 $("#addTbl tbody").append($("#addTbl").data("rowTag"));

 fnSetRowNo();
}

function fnDelRow(obj){
 if($("#addTbl tr").length < 3){
  alert("���̻� ������ �� �����ϴ�.");
  return false;
 }else{
	if(confirm("�׸��� ���� �Ͻðڽ��ϱ�?")) {
		$(obj).parent().parent().remove();
	} else {
        return false;
        }	 
  
  
  fnSetRowNo();
 }
}
function fnSetRowNo(){
    var span = $("#addTbl tbody tr td span");  
//	var tr_id = $("#addTbl tbody tr#id").val();  
	//alert(tr_id);
    var span_cnt = span.length; // tbody���� tr�ȿ� td�ȿ� span �±׵��� ����
    if(span_cnt == 1){ // span�� �Ѱ��ϰ�� ���� ���̱�
        $("span.#qidrownum").text("Q1")
//		$("tr.#tr_q1").text("Q1")
    }else{ // span�� �������ϰ�� ���� ���̱�
        $.each(span,function(index){
			 index=index+1;
           $(this).text('Q'+index);
           $(this).closest("tr").attr("id",'Q'+index); 
        });
    } 
}
 
 function rowCheDel() {
  var $obj = $("input[name='chk']");
  var checkCount = $obj.size();
  for ( var i = 0; i < checkCount; i++) {
   if ($obj.eq(i).is(":checked")) {
    $obj.eq(i).parent().parent().remove();
   }
  }
 }
 
 
 $('td input').click(function(){
    $(this).parent().remove();
});
</script>

<script>

function fnPopUp(el, url, cmt) {
	var question = $(el).prev().val(); 
	var qidx = $(el).parent().parent().find(".qidrownum").text();
	question = '';
	
 if(document.form1.poll_type.value == ''){	alert('������ �����ϼ���.');	return;	}
 if(document.form1.poll_st.value == ''){	alert('���Ÿ���� �����ϼ���.');	return;	}
 if(document.form1.poll_su.value == ''){	alert('ȸ���� �Է��ϼ���.');	return;	}
 if(document.form1.start_dt.value == ''){	alert('������������ �Է��ϼ���.');	return;	}
   
 newwindow=window.open(url+'?qidx='+qidx+'&question='+question+'&poll_id='+<%=poll_id%>+'&cmd='+cmt,'question','height=700,width=800');
 if (window.focus) {newwindow.focus()}
 return false;
}
</script>

<script>
function save()
	{
		if(confirm('����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
		//	if(fm.question.value == ''){		alert('���������� �Է��Ͻʽÿ�');	return;	}
		//	else if(fm.answer1.value == ''){	alert('���1 �Է��Ͻʽÿ�');	return;	}
		//	else if(fm.answer2.value == ''){	alert('���2 �Է��Ͻʽÿ�');	return;	}
		
		
			fm.target='i_no';
			fm.submit();
		}
	}
	
	
function Change (target,type) 
{  
       if ( target.value == target.defaultValue && type==0) target.value = ''; 
       if ( !target.value && type==1) target.value = target.defaultValue; 
} 	

 // TEXTAREA �ִ밪 üũ

    function fn_TextAreaInputLimit() {

        var tempText = $("textarea[name='poll_title']");

        var tempChar = "";                                        // TextArea�� ���ڸ� �ѱ��ھ� ��´�

        var tempChar2 = "";                                        // ����� ���ڵ��� ��� ���� ����

        var countChar = 0;                                        // �ѱ��ھ� ��� ���ڸ� ī��Ʈ �Ѵ�

        var tempHangul = 0;                                        // �ѱ��� ī��Ʈ �Ѵ�

        var maxSize = 250;                                        // �ִ밪

        

        // ���ڼ� ����Ʈ üũ�� ���� �ݺ�

        for(var i = 0 ; i < tempText.val().length; i++) {

            tempChar = tempText.val().charAt(i);

 

            // �ѱ��� ��� 2 �߰�, ������ ��� 1 �߰�

            if(escape(tempChar).length > 4) {

                countChar += 2;

                tempHangul++;

            } else {

                countChar++;

            }

        }

        

        // ī��Ʈ�� ���ڼ��� MAX ���� �ʰ��ϰ� �Ǹ� ���� ��ġ������ ����� �Ѵ�.(�ѱ� �Է� üũ)

        // ���뿡 �ѱ��� �ԷµǾ� �ִ� ��� �ѱۿ� �ش��ϴ� ī��Ʈ ��ŭ�� ��ü ī��Ʈ���� �� ���ڰ� maxSize���� ũ�� ����

        if((countChar-tempHangul) > maxSize) {

            alert("�ִ� ���ڼ��� �ʰ��Ͽ����ϴ�.");

            

            tempChar2 = tempText.val().substr(0, maxSize-1);

            tempText.val(tempChar2);

        }

    }
	
	//����Ʈ ����	
function list_go()
{
	var fm = document.form1;
	location = "survey_list_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>";
	
}
</script>
<style>
textarea {
    width: 100%;
    height: 100px;
    padding: 12px 20px;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    background-color: #f8f8f8;
    font-size: 16px;
    resize: none;
}
input[name=poll_title] {
    width: 70%;
    padding: 4px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 1px solid #929292;
    border-radius: 2px;
	
}
input[name=start_dt], input[name=end_dt], input[name=poll_su]  {
    width: 40%;
    padding: 4px 10px;
    margin: 8px 0;
    box-sizing: border-box;
	border: 1px solid #929292;
    border-radius: 2px;
	
}
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}

input[name=question] {
    width: 80%;
    padding: 4px 10px;
    margin: 4px 0;
    box-sizing: border-box;
    border: 1px none ;
    border-radius: 4px;
	color: red;
	font-size: 1.2em;
}


</style>
</head>
<body>
<form name='form1' method='post' action=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type="hidden" name="poll_id" id="poll_id" value='<%=poll_id%>'>
<div class="navigation">
	<span class=style1>�ݼ��� ></span><span class=style5>���׸����</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td align="right" colspan="2"><input type="button" class="button button4" value="���" onclick="list_go()"/></td>
	</tr>
	<tr>
		<td class=h><br/></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line colspan="2">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class="title" width="20%" height="35">����</td>
					<td class="title" width="20%" height="35">���Ÿ��</td>
					<td class="title" width="20%" height="35">ȸ��</td>
					<td class="title" width="20%" height="35">�Ⱓ</td>
					<td class="title" width="20%" height="35">��뱸��</td>
				</tr>
				<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
				<script>
				$(function() {
					$("#poll_st").chained("#poll_type");
				});
				</script>				
				<tr>
					<td align="center" height="35">
						<select id="poll_type" name="poll_type"  class="select">
							<option value = "" selected> ���� </option>
							<option value = "���">���</option>
							<option value = "��ȸ����">��ȸ����</option>
							<option value = "���ó��">���ó��</option>
						</select>
					</td>
					<td align="center" height="35">
						<select id="poll_st" name="poll_st"  class="select">
							<option value = "" selected> ���� </option>
							<option class="���" value = "�ű�"> �ű� </option>
							<option class="���" value = "����"> ���� </option>
							<option class="���" value = "����"> ���� </option>
							<option class="���" value = "�縮��"> �縮�� </option>
							<option class="���" value = "����Ʈ"> ����Ʈ </option>
							<option class="��ȸ����" value = "��ȸ����"> ��ȸ���� </option>
							<option class="���ó��" value = "���ó��"> ���ó�� </option>
						</select>
					</td>
					<td align="center" height="35"><input type="text" name="poll_su" id="poll_su" value="<%//=poll_su%>" style="align:center;"size="10">ȸ��</td>
					<td align="center" height="35">
						<input type="text" name="start_dt" id="start_dt" title="YYYY-MM-DD" size="12" data-bind="kendoDatePicker: startDate">~<input type="text" name="end_dt" id="end_dt" title="YYYY-MM-DD" size="12" data-bind="kendoDatePicker: endDate">
					</td>
                    <td align="center" height="35">
                      <select name='use_yn' id='use_yn'  class="select">
                        <option value='Y' selected >���</option>
                        <option value='N'>�̻��</option>
                      </select></td>

				</tr>
				
			</table>
		</td>
	</tr>
	
	<tr>
		<td class=h></td>
	</tr>
	<tr> 
		<td class=line colspan="2">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class="title"  width="20%" height="35">�ȳ�����</td>
					<td align="">&nbsp;&nbsp;
					<input type="text" name="poll_title" id="poll_title" size="100" value="�ѱ�128��/ ����+���� 256 ���ڱ��� �Է��� �� �ֽ��ϴ�." onFocus='Change(this,0)' onBlur='Change(this,1)' onkeyup="javascript:fn_TextAreaInputLimit();" style="color:#A9A9A9;">&nbsp;&nbsp;( * ��������ȭ�� ��ܿ� �����ִ� ���� �Դϴ�.)</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	
	<tr>
		<td class=h colspan="2"><hr width="100%"></hr></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td align="left"><input type="button" class="button button4" value="�����߰�" onclick="fnPopUp(this, 'answer_i.jsp', 'n_save')"/></td>
		<td align="right"><input type="button" class="button button4" value="����" onclick="use_yn_save()"/></td>
	</tr>

	<tr>
		<td class=h></td>
	</tr>
	
</table>	

		




</form>	
</body>
</html>