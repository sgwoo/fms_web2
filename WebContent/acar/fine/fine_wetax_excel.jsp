<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ page import="java.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");	

	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	Hashtable ht = null;
	
// 	List<Map<String, Object>> list = null;
	
	Vector unRegs = a_fdb.getUnRegList();
	int unReg_size = unRegs.size();
	
	String[] carNoArray = new String[unReg_size];
	String[] paidNoArray = new String[unReg_size];
	String[] vioDtArray = new String[unReg_size];
	String[] vioPlaArray = new String[unReg_size];
	String[] vioContArray = new String[unReg_size];
	String[] paidEndDtArray = new String[unReg_size];
	String[] paidAmtArray = new String[unReg_size];
	String[] imposeDtArray = new String[unReg_size];
		
	for(int i = 0 ; i < unReg_size ; i++){
		HashMap<String, Object> map= new HashMap<>();
		 ht = (Hashtable)unRegs.elementAt(i);
		 carNoArray[i] = (String)ht.get("CAR_NO");
		 paidNoArray[i] = (String)ht.get("PAID_NO");
		 vioDtArray[i] = (String)ht.get("VIO_DT");
		 vioPlaArray[i] = (String)ht.get("VIO_PLA");
		 vioContArray[i] = (String)ht.get("VIO_CONT");
		 paidEndDtArray[i] = (String)ht.get("PAID_END_DT");
		 paidAmtArray[i] = (String)ht.get("PAID_AMT");
		 imposeDtArray[i] = (String)ht.get("IMPOSE_DT");
	}

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style>

</style>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	
	var uploadFlag = "N"; // ���� ���ε� �÷���
	var convertFlag = "N"; // ������ ��ȯ �÷���
	var unRegFlag = "N";
	
	// ���� ����
	function readExcel() {
		if($("#fileUpload").val() == "") {
			alert("������ �����Ͻ� �� ���ε��ϼ���.");
			return;
		} 
		unRegFlag = "N";
		uploadFlag = "Y";
		convertFlag = "N";
		$("#fileDiv").css("display","none");
		$("#tbdy").empty();
		showLoadingBar();
		setTimeout(function() {
	    var input = document.getElementById("fileUpload");
	    var reader = new FileReader();
	    var rowsParam;
	    reader.onload = function () {
	        var data = reader.result;
	        var workBook = XLSX.read(data, { type: 'binary' });
	        workBook.SheetNames.forEach(function (sheetName) {
	            var rows = XLSX.utils.sheet_to_json(workBook.Sheets[sheetName]);
	            rowsParam = rows;
	            var tags = "";
	            for(var i=0; i<rows.length; i++) {
	              var seq = i+1;
	      	      tags += '<tr>'
	      	      tags += '<td width="3%" align="center">'+seq+' </td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value11" value="'+rows[i]["�����"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="3" value="'+rows[i]["�ΰ�����"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value1" value="'+rows[i]["�ΰ����"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value10" value="'+rows[i]["���ڳ��ι�ȣ"]+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value6" value="'+rows[i]["��������"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="value7_1" value="'+rows[i]["�ΰ��ݾ�"]+'" style=width:98%;text-align:right;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="value7" value="'+rows[i]["���αݾ�"]+'" style="width:98%;text-align:right;"/>' + '</td>'
	      	      tags += '<td width="12%" align="center">' + '<input type="text" name="target" value="'+rows[i]["�������"]+'" style="width:98%" disabled/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value8" value="'+rows[i]["������ȣ"]+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value4" value="'+rows[i]["�����׸�1"]+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value3" value="'+rows[i]["�����׸�2"]+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value5" value="'+rows[i]["���� ��ȣ"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="button" name="delete" value="����" style="width:90%;text-align: center;"/>' + '</td>'
	      	      tags += '</tr>'
	            }
	            $("#tbdy").append(tags);
	            uploadFlag="Y";
	            $("#save").css("display","block");
	        })
	    };
	    reader.readAsBinaryString(input.files[0]);
		
	   		hideLoadingBar();
		});
	}
	// �ε��� ����
	function showLoadingBar() {
	    var maskHeight = $(document).height();
	    var maskWidth = window.document.body.clientWidth;

	    var mask = "<div id='mask' style='position:absolute; z-index:9000; background-color:#000000; display:none; left:0; top:0;'></div>";
	    var loadingImg = '';

	    loadingImg += "<div id='loadingImg' style='position:absolute; left:50%; top:40%; display:none; z-index:10000;'>";
	    loadingImg += "    <img src='/acar/images/center/ajax-loader3.gif'/>";
	    loadingImg += "</div>";

	    $('body').append(mask).append(loadingImg);

	    $('#mask').css({
	        'width' : maskWidth
	        , 'height': maskHeight
	        , 'opacity' : '0.3'
	    });

	    $('#mask').show();
	    $('#loadingImg').show();
	}
	// �ε��� ����
	function hideLoadingBar() {
		$('#mask, #loadingImg').hide();
		$('#mask, #loadingImg').remove();
	}
	
	// ���� ������ ��ȯ
	function fineDataConvert() {
		if(unRegFlag == "Y") {
			alert("�̵�� �����ʹ� ��ȯ�� �� �� �����ϴ�.") 
			return;
		}
		convertFlag = "Y";
		if (uploadFlag == "N") {
			alert("��ȯ�� ���� �����͸� ���� �ҷ�������.");
		}
		showLoadingBar();
		setTimeout(function() {
			var trSize = $("#tb > tbody tr").length;
			for (var i = 0; i < trSize; i++) {
				if ($("input[name=target]").eq(i).val().indexOf("�������:") > 0) {
					var placeStIndex = $("input[name=target]").eq(i).val().indexOf(
							"�������:");
					var placeEndIndex = $("input[name=target]").eq(i).val()
							.indexOf("�����Ͻ�");
					var value4 = $("input[name=target]").eq(i).val().substring(
							placeStIndex, (placeEndIndex - 1));
					$("input[name=value4]").eq(i).val(value4);
				}
	
				if ($("input[name=target]").eq(i).val().indexOf("�����Ͻ�:") > 0) {
					var vioDtStIndex = $("input[name=target]").eq(i).val().indexOf(
							"�����Ͻ�:");
					var value5 = $("input[name=target]").eq(i).val().substring(
							vioDtStIndex);
					$("input[name=value3]").eq(i).val(value5);
				}
	
				if ($("input[name=value5]").eq(i).val() == " "
						|| $("input[name=value5]").eq(i).val() == "") {
					$("input[name=value5]").eq(i).css("background", "red");
				}
				var value4 = $("input[name=value4]").eq(i).val().replace("�������:",
						"");
				$("input[name=value4]").eq(i).val(value4);
	
				if ($("input[name=value4]").eq(i).val() == ""
						|| $("input[name=value4]").eq(i).val() == " ") {
					$("input[name=value4]").eq(i).css("background", "red");
				}
	
				var value3 = $("input[name=value3]").eq(i).val().replace("�����Ͻ�:","");
				value3 = value3.replaceAll(".","-");
				$("input[name=value3]").eq(i).val(value3);
	
				if ($("input[name=value3]").eq(i).val() == ""
						|| $("input[name=value3]").eq(i).val() == " ") {
					$("input[name=value3]").eq(i).css("background", "red");
				}
	
				if($("input[name=value5]").eq(i).val().length > 8) {
					$("input[name=value5]").eq(i).val("");
					$("input[name=value5]").eq(i).css("background","red");
				}
				
				if($("input[name=value8]").eq(i).val().indexOf(".") > 0) {
					$("input[name=value8]").eq(i).css("background", "red");
				}
			}
   			hideLoadingBar();
		});
	}
	
	// validation check �� ����
	function saveWetax() {
		if(convertFlag == "N" && unRegFlag != "Y") {
			alert("���·� ������ ��ȯ�� ���� �������ּ���.");
			return;
		}
		var result1 = [];
		var result2 = [];
		var result3 = [];
		var result4 = [];
		var trSize = $("#tb > tbody tr").length;
		fm = document.form1;
		fm.start_row.value = '1';
		fm.value_line.value = trSize;
		if(unRegFlag == "Y") {
	 		for(var i=0; i<trSize; i++) {
				if($("input[name=value8]").eq(i).val().indexOf(".") > 0) {
					result1.push(i+1);
				}
				if ($("input[name=value4]").eq(i).val() == ""
					|| $("input[name=value4]").eq(i).val() == " ") {
					result2.push(i+1);
				}
				if ($("input[name=value3]").eq(i).val() == ""
					|| $("input[name=value3]").eq(i).val() == " ") {
					result3.push(i+1);
				}
				if ($("input[name=value5]").eq(i).val() == ""
					|| $("input[name=value5]").eq(i).val() == " ") {
					result4.push(i+1);
				}
			}
			if(result1.length > 0 || result2.length > 0 || result3.length > 0 || result4.length > 0) {
				alert("�̵�� �����ʹ� ���� ���, ���� �Ͻ�, ���� ��ȣ, ���� ��ȣ�� �ʼ������� �ԷµǾ�� �մϴ�.\n ����� ��ġ �ʴ� �����ʹ� ���� �� �������ּ���.");
				return;
				
			} 		
		}

		
// 		if(result1.length > 0 && result2.length > 0 && result3.length > 0 && result4.length > 0) {
// 			alert("������ȣ "+ result1 + "�� �׸�\n " + "������� " + result2 + "�� �׸�\n " + "�����Ͻ� " + result3 + "�� �׸�\n" + "������ȣ " + result4 + "�� �׸��� Ȯ���ϼ���.");
// 			return;
// 		} else if(result1.length > 0 && result2.length > 0 && result3.length > 0 && result4.length < 0) {
// 			alert("������ȣ "+ result1 + "�� �׸�\n " + "������� " + result2 + "�� �׸�\n " + "�����Ͻ� " + result3 + "�� �׸��� Ȯ���ϼ���.");
// 			return;
// 		} else if(result1.length > 0 && result2.length > 0 && result3.length < 0 && result4.length < 0) {
// 			alert("������ȣ "+ result1 + "�� �׸�\n " + "������� " + result2 + "�� �׸��� Ȯ���ϼ���. ");
// 			return;
// 		} else if(result1.length > 0 && result2.length < 0 && result3.length < 0 && result4.length < 0) {
// 			alert("������ȣ "+ result1 + "�� �׸��� Ȯ���ϼ���.");
// 			return;
// 		}  
		
		for(var i=0; i<trSize; i++) {
			//���� �� ���� ���� ���Խ�
			var regExp = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+��<>@\#$%&\ '\"\\(\=]/gi;
			var str = $("input[name=value3]").eq(i).val();
			var str2 = $("input[name=value6]").eq(i).val();
			var text = str.replace(regExp, "");
			var text2 = str2.replace(regExp, "");
			text = text.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
			text2 = text2.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
			$("input[name=value3]").eq(i).val(text);
			$("input[name=value6]").eq(i).val(text2);
		}
		
		if(confirm("�����Ͻðڽ��ϱ�?")) {
			unRegFlag = "N";
			showLoadingBar();
			setTimeout(function() {
				fm = document.form1;
				fm.start_row.value = '0';
				fm.value_line.value = trSize;
				
				fm.action = 'fine_wetax_excel_a.jsp';
				
				fm.submit();
			});
		} else {
			return;
		}
	}
	
	function fileChange() {
		uploadFlag = "N";
		convertFlag = "N";
		unRegFlag = "N";
	}
	
	function unregisteredPop() {
		unRegFlag = "Y";
		if(confirm("�̵�� ����Ʈ�� ��ȸ�Ͻðڽ��ϱ�?")) {
			$("#fileDiv").css("display","none");
			$("#tbdy").empty();
			var carNoArray = "<%=Arrays.toString(carNoArray)%>".replaceAll("[","").replaceAll("]","").split(",");
			var	paidNoArray = "<%=Arrays.toString(paidNoArray)%>".replaceAll("[","").replaceAll("]","").split(",");
			var vioDtArray = "<%=Arrays.toString(vioDtArray)%>".replaceAll("[","").replaceAll("]","").split(",");
			var vioPlaArray = "<%=Arrays.toString(vioPlaArray)%>".replaceAll("[","").replaceAll("]","").split(",");
			var vioContArray = "<%=Arrays.toString(vioContArray)%>".replaceAll("[","").replaceAll("]","").split(",");
			var paidEndDtArray = "<%=Arrays.toString(paidEndDtArray)%>".replaceAll("[","").replaceAll("]","").split(",");
			var paidAmtArray = "<%=Arrays.toString(paidAmtArray)%>".replaceAll("[","").replaceAll("]","").split(",");
			var imposeDtArray = "<%=Arrays.toString(imposeDtArray)%>".replaceAll("[","").replaceAll("]","").split(",");
			var tags = "";
			if(paidNoArray[0] == "") {
				alert("�̵�ϵ� ����Ʈ�� �����ϴ�.");
				return;
			}
			for(var i=0; i<carNoArray.length; i++) {
				 var seq = i+1;
	      	      tags += '<tr>'
	      	      tags += '<td width="3%" align="center">'+seq+' </td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value11" value="'+vioContArray[i].trim()+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="3" value="" style="width:98%;text-align: center;" disabled/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value1" value="'+imposeDtArray[i].trim()+'" style="width:98%;text-align: center;" disabled/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value10" value="" style="width:98%" disabled/> ' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value6" value="'+paidEndDtArray[i].trim()+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="value7_1" value="" style=width:98%;text-align:right;" disabled/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="value7" value="'+paidAmtArray[i].trim()+'" style="width:98%;text-align:right;"/>' + '</td>'
	      	      tags += '<td width="12%" align="center">' + '<input type="text" name="target" value="" style="width:98%" disabled/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value8" value="'+paidNoArray[i].trim()+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value4" value="'+vioPlaArray[i].trim()+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value3" value="'+vioDtArray[i].trim()+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value5" value="'+carNoArray[i].trim()+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="button" name="delete" value="����" style="width:90%;text-align: center;"/>' + '</td>'
	      	      tags += '</tr>'
			}
			
			$("#tbdy").append(tags);
			uploadFlag="Y";
			$("#save").css("display","block");
		}
	}
	
	// �ο� ���� 
	$(document).on("click","[name=delete]", function(){
		if(confirm("�����Ͻðڽ��ϱ�?")) {
			var idx = $("[name=delete]").index(this);
			$("#tbdy").children().eq(idx).remove();
		} else {
			return;
		}
	});  
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post'>
    <input type='hidden' name='user_id' value='<%= user_id %>'>
    <input type='hidden' name='value_line' value=''>
<%-- 	<input type='hidden' name='gubun1' value='<%= gubun1 %>'> --%>
<%-- 	<input type='hidden' name='row_size' value='<%= rowSize %>'> --%>
<%-- 	<input type='hidden' name='col_size' value='<%= columnSize %>'> --%>
	<input type='hidden' name='start_row' value=''>
    <table border="0" cellspacing="0" cellpadding="0" width=570>
      <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�������� > ���·���� > <span class=style1><span class=style5>��������(���ý�) ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>����</td>
                    <td>&nbsp;
				    <input id="fileUpload" type="file" style="margin-top:4px" onchange="fileChange()"><input class="button btn-submit" type="button" style="float:right" value="���� ���ε�" onclick="readExcel()"/>
			        </td>
					<td align="center"></td>
                </tr>
            </table>
            
		</td>
    </tr>
    <tr>
    </tr>	  
    <tr>
        <td class=h>&nbsp;</td>
    </tr>
  </table>
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		<input type="button" class="button btn-submit" style="float: right;" value="���·� ������ ��ȯ" onclick="fineDataConvert()"/>
		<input type="button" class="button btn-submit" style="float: left; background: RGB(27,86,48);" value="�̵�� ������ ��ȸ" onclick="unregisteredPop()"/>
		</tr>  
	      <tr>          
	          <td width='3%'class='title'>NO</td>
              <td width='10%'class='title'>�����</td>			
              <td width='3%' class='title'>�ΰ�<br>����</td>			
              <td width='5%' class='title'>�ΰ����</td>
              <td width='5%'class='title'>���ڳ��ι�ȣ</td>					
              <td width='5%'class='title'>��������</td>					
              <td width='3%' class='title'>�ΰ�</br>�ݾ�</td>
              <td width='3%'class='title'>����</br>�ݾ�</td>
              <td width='12%'class='title'>�������</td>							
              <td width='10%'class='title'>������ȣ</td>							
              <td width='10%'class='title'>�����׸�1(���)</td>
              <td width='10%'class='title'>�����׸�2(�Ͻ�)</td>
              <td width='5%'class='title'>������ȣ</td>	
              <td width='3%'class='title'></td>		
	      </tr>
	  </table>
	  <table id="tb" border="1" cellspacing="0" cellpadding="0" width='100%'>
	  	<tbody id="tbdy">
	  		<div id="fileDiv">������ ���� ����ϼ���.</div>
	  	</tbody>
	  </table>
	  <input id="save" type="button" class="button btn-submit" value="����" style="float: right;margin-top: 1%;margin-bottom: 1%;display: none;width: 5%;height: 5%;" onclick="saveWetax()" />
  </form>
</center>
</body>
</html>
