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
	
	var uploadFlag = "N"; // 파일 업로드 플래그
	var convertFlag = "N"; // 데이터 변환 플래그
	var unRegFlag = "N";
	
	// 엑셀 리딩
	function readExcel() {
		if($("#fileUpload").val() == "") {
			alert("파일을 선택하신 후 업로드하세요.");
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
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value11" value="'+rows[i]["과목명"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="3" value="'+rows[i]["부과구분"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value1" value="'+rows[i]["부과년월"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value10" value="'+rows[i]["전자납부번호"]+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value6" value="'+rows[i]["납기일자"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="value7_1" value="'+rows[i]["부과금액"]+'" style=width:98%;text-align:right;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="text" name="value7" value="'+rows[i]["납부금액"]+'" style="width:98%;text-align:right;"/>' + '</td>'
	      	      tags += '<td width="12%" align="center">' + '<input type="text" name="target" value="'+rows[i]["과세대상"]+'" style="width:98%" disabled/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value8" value="'+rows[i]["납세번호"]+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value4" value="'+rows[i]["위반항목1"]+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="10%" align="center">' + '<input type="text" name="value3" value="'+rows[i]["위반항목2"]+'" style="width:98%"/>' + '</td>'
	      	      tags += '<td width="5%" align="center">' + '<input type="text" name="value5" value="'+rows[i]["차량 번호"]+'" style="width:98%;text-align: center;"/>' + '</td>'
	      	      tags += '<td width="3%" align="center">' + '<input type="button" name="delete" value="삭제" style="width:90%;text-align: center;"/>' + '</td>'
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
	// 로딩바 시작
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
	// 로딩바 종료
	function hideLoadingBar() {
		$('#mask, #loadingImg').hide();
		$('#mask, #loadingImg').remove();
	}
	
	// 엑셀 데이터 변환
	function fineDataConvert() {
		if(unRegFlag == "Y") {
			alert("미등록 데이터는 변환을 할 수 없습니다.") 
			return;
		}
		convertFlag = "Y";
		if (uploadFlag == "N") {
			alert("변환할 엑셀 데이터를 먼저 불러오세요.");
		}
		showLoadingBar();
		setTimeout(function() {
			var trSize = $("#tb > tbody tr").length;
			for (var i = 0; i < trSize; i++) {
				if ($("input[name=target]").eq(i).val().indexOf("위반장소:") > 0) {
					var placeStIndex = $("input[name=target]").eq(i).val().indexOf(
							"위반장소:");
					var placeEndIndex = $("input[name=target]").eq(i).val()
							.indexOf("위반일시");
					var value4 = $("input[name=target]").eq(i).val().substring(
							placeStIndex, (placeEndIndex - 1));
					$("input[name=value4]").eq(i).val(value4);
				}
	
				if ($("input[name=target]").eq(i).val().indexOf("위반일시:") > 0) {
					var vioDtStIndex = $("input[name=target]").eq(i).val().indexOf(
							"위반일시:");
					var value5 = $("input[name=target]").eq(i).val().substring(
							vioDtStIndex);
					$("input[name=value3]").eq(i).val(value5);
				}
	
				if ($("input[name=value5]").eq(i).val() == " "
						|| $("input[name=value5]").eq(i).val() == "") {
					$("input[name=value5]").eq(i).css("background", "red");
				}
				var value4 = $("input[name=value4]").eq(i).val().replace("위반장소:",
						"");
				$("input[name=value4]").eq(i).val(value4);
	
				if ($("input[name=value4]").eq(i).val() == ""
						|| $("input[name=value4]").eq(i).val() == " ") {
					$("input[name=value4]").eq(i).css("background", "red");
				}
	
				var value3 = $("input[name=value3]").eq(i).val().replace("위반일시:","");
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
	
	// validation check 및 저장
	function saveWetax() {
		if(convertFlag == "N" && unRegFlag != "Y") {
			alert("과태료 데이터 변환을 먼저 진행해주세요.");
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
				alert("미등록 데이터는 위반 장소, 위반 일시, 차량 번호, 납세 번호가 필수적으로 입력되어야 합니다.\n 등록을 원치 않는 데이터는 삭제 후 진행해주세요.");
				return;
				
			} 		
		}

		
// 		if(result1.length > 0 && result2.length > 0 && result3.length > 0 && result4.length > 0) {
// 			alert("납세번호 "+ result1 + "번 항목\n " + "위반장소 " + result2 + "번 항목\n " + "위반일시 " + result3 + "번 항목\n" + "차량번호 " + result4 + "번 항목을 확인하세요.");
// 			return;
// 		} else if(result1.length > 0 && result2.length > 0 && result3.length > 0 && result4.length < 0) {
// 			alert("납세번호 "+ result1 + "번 항목\n " + "위반장소 " + result2 + "번 항목\n " + "위반일시 " + result3 + "번 항목을 확인하세요.");
// 			return;
// 		} else if(result1.length > 0 && result2.length > 0 && result3.length < 0 && result4.length < 0) {
// 			alert("납세번호 "+ result1 + "번 항목\n " + "위반장소 " + result2 + "번 항목을 확인하세요. ");
// 			return;
// 		} else if(result1.length > 0 && result2.length < 0 && result3.length < 0 && result4.length < 0) {
// 			alert("납세번호 "+ result1 + "번 항목을 확인하세요.");
// 			return;
// 		}  
		
		for(var i=0; i<trSize; i++) {
			//공백 및 문자 제거 정규식
			var regExp = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\ '\"\\(\=]/gi;
			var str = $("input[name=value3]").eq(i).val();
			var str2 = $("input[name=value6]").eq(i).val();
			var text = str.replace(regExp, "");
			var text2 = str2.replace(regExp, "");
			text = text.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
			text2 = text2.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
			$("input[name=value3]").eq(i).val(text);
			$("input[name=value6]").eq(i).val(text2);
		}
		
		if(confirm("저장하시겠습니까?")) {
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
		if(confirm("미등록 리스트를 조회하시겠습니까?")) {
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
				alert("미등록된 리스트가 없습니다.");
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
	      	      tags += '<td width="3%" align="center">' + '<input type="button" name="delete" value="삭제" style="width:90%;text-align: center;"/>' + '</td>'
	      	      tags += '</tr>'
			}
			
			$("#tbdy").append(tags);
			uploadFlag="Y";
			$("#save").css("display","block");
		}
	}
	
	// 로우 삭제 
	$(document).on("click","[name=delete]", function(){
		if(confirm("삭제하시겠습니까?")) {
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;차량관리 > 과태료관리 > <span class=style1><span class=style5>엑셀파일(위택스) 등록</span></span></td>
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
                    <td class='title'>파일</td>
                    <td>&nbsp;
				    <input id="fileUpload" type="file" style="margin-top:4px" onchange="fileChange()"><input class="button btn-submit" type="button" style="float:right" value="엑셀 업로드" onclick="readExcel()"/>
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
		<input type="button" class="button btn-submit" style="float: right;" value="과태료 데이터 변환" onclick="fineDataConvert()"/>
		<input type="button" class="button btn-submit" style="float: left; background: RGB(27,86,48);" value="미등록 데이터 조회" onclick="unregisteredPop()"/>
		</tr>  
	      <tr>          
	          <td width='3%'class='title'>NO</td>
              <td width='10%'class='title'>과목명</td>			
              <td width='3%' class='title'>부과<br>구분</td>			
              <td width='5%' class='title'>부과년월</td>
              <td width='5%'class='title'>전자납부번호</td>					
              <td width='5%'class='title'>납기일자</td>					
              <td width='3%' class='title'>부과</br>금액</td>
              <td width='3%'class='title'>납부</br>금액</td>
              <td width='12%'class='title'>과세대상</td>							
              <td width='10%'class='title'>납세번호</td>							
              <td width='10%'class='title'>위반항목1(장소)</td>
              <td width='10%'class='title'>위반항목2(일시)</td>
              <td width='5%'class='title'>차량번호</td>	
              <td width='3%'class='title'></td>		
	      </tr>
	  </table>
	  <table id="tb" border="1" cellspacing="0" cellpadding="0" width='100%'>
	  	<tbody id="tbdy">
	  		<div id="fileDiv">파일을 먼저 등록하세요.</div>
	  	</tbody>
	  </table>
	  <input id="save" type="button" class="button btn-submit" value="저장" style="float: right;margin-top: 1%;margin-bottom: 1%;display: none;width: 5%;height: 5%;" onclick="saveWetax()" />
  </form>
</center>
</body>
</html>
