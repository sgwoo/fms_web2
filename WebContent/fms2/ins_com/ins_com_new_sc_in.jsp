<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.insur.*"%>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	Vector vt = ic_db.getInsComNewList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.3.0/jquery.form.js"></script> 
<script language='javascript'>
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
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
	
	function save() {
		var size = <%=vt_size%>;
		var insurCodeArray = "";
		var value15Array = "";
		var value17Array = "";
		var value18Array = "";
		var value19Array = "";
		var value20Array = "";
		var value21Array = "";
		var value26Array = "";
		var regCodeArray = "";
		var seqArray = "";
		var checkedCount = 0;
		
		for(var y=0; y<size; y++) {
			if($(".ch_cd").eq(y).is(":checked") == true) {
				checkedCount = checkedCount + 1
			}
		} 
		
		if(checkedCount == 0) {
			alert("저장할 항목을 선택하세요.");
			return;
		}
		
		for(var i=0; i<size; i++) {
			// 입력 값 validation check
			if($(".ch_cd").eq(i).is(":checked") == true) {
				var count = 0;
				var checkedSize = $("input:checkbox[name=ch_cd]:checked").length;
				
				// 증권번호 중복 체크			
				for(var x=0; x<size; x++) {
						if($(".value15").eq(i).val() == $(".value15").eq(x).val()) {
							count++;
						}
				}
				
				if(count > 1) {
					alert("중복된 증권번호가 있습니다. 확인 후에 다시 저장하세요.");
					return;
				}
				if($(".value15").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 증권번호 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value17").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 대인배상 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value18").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 대인배상 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value19").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 대물배상 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value20").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 자기신체사고 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value20").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 무보험차상해 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				
				if(insurCodeArray.length == 0) {
					insurCodeArray += $(".insur_code").eq(i).val();
					value15Array += $(".value15").eq(i).val();
				    value17Array += $(".value17").eq(i).val();
					value18Array += $(".value18").eq(i).val();
					value19Array += $(".value19").eq(i).val();
					value20Array += $(".value20").eq(i).val();
					value21Array += $(".value21").eq(i).val();
					value26Array += $(".value26").eq(i).val();
					regCodeArray += $(".reg_code").eq(i).val();
					seqArray += $(".seq").eq(i).val();
				} else {
					insurCodeArray += (","+$(".insur_code").eq(i).val());
					value15Array += (","+$(".value15").eq(i).val());
				    value17Array += (","+$(".value17").eq(i).val());
					value18Array += (","+$(".value18").eq(i).val());
					value19Array += (","+$(".value19").eq(i).val());
					value20Array += (","+$(".value20").eq(i).val());
					value21Array += (","+$(".value21").eq(i).val());
					value26Array += (","+$(".value26").eq(i).val());
					regCodeArray += (","+$(".reg_code").eq(i).val());
					seqArray += (","+$(".seq").eq(i).val());
				}
			}
		}
			
			$("#insurCodeArray").val(insurCodeArray);
			$("#value15Array").val(value15Array);
			$("#value17Array").val(value17Array);
			$("#value18Array").val(value18Array);
			$("#value19Array").val(value19Array);
			$("#value20Array").val(value20Array);
			$("#value21Array").val(value21Array);
			$("#value26Array").val(value26Array);
			$("#arraySize").val(checkedCount);
			$("#regCodeArray").val(regCodeArray);
			$("#seqArray").val(seqArray);
			
			if(confirm("저장하시겠습니까?")) {
				setTimeout(function() {
					fm = document.form2;
					fm.action = 'ins_com_new_sc_save_a.jsp';
					fm.submit();
				});
			} else {
				return;
			}
	}
	
	function next() {
		var size = <%=vt_size%>;
		var regCodeArray = "";
		var seqArray = "";
		var checkedCount = 0;
		
		for(var y=0; y<size; y++) {
			if($(".ch_cd").eq(y).is(":checked") == true) {
				checkedCount = checkedCount + 1
			}
		} 
		
		if(checkedCount == 0) {
			alert("확인처리할 항목을 선택하세요.");
			return;
		}
		
		for(var i=0; i<size; i++) {
			// 입력 값 validation check
			if($(".ch_cd").eq(i).is(":checked") == true) {
				
				if($(".save_yn").eq(i).val() == "N") {
					alert((i+1)+"번 째 행의 데이터가 저장되지 않았습니다. 확인 후 다시 확인처리하세요.");
					return;
				}
				
				if($(".insur_code").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 개발원 코드 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value15").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 증권번호 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value17").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 대인배상 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value18").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 대인배상 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value19").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 대물배상 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value20").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 자기신체사고 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value20").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 무보험차상해 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if(regCodeArray.length == 0) {
					regCodeArray += $(".reg_code").eq(i).val();
					seqArray += $(".seq").eq(i).val();
				} else {
					regCodeArray += (","+$(".reg_code").eq(i).val());
					seqArray += (","+$(".seq").eq(i).val());
				}
			}
		}
			$("#arraySize").val(checkedCount);
			$("#regCodeArray").val(regCodeArray);
			$("#seqArray").val(seqArray);
			
			if(confirm("확인처리 하시겠습니까?")) {
				setTimeout(function() {
					fm = document.form2;
					fm.action = 'ins_com_new_sc_confirm_a.jsp';
					fm.submit();
				});
			} else {
				return;
			}
	}
	
	$(document).on("focusout","[name=value17]", function(){
			var idx = $("[name=value17]").index(this);
			var value17 = $("[name=value17]").eq(idx).val();
			var removeCommaValue17 = value17.replaceAll(',','');
			$("[name=value17]").eq(idx).val(removeCommaValue17);
	}); 
	
	$(document).on("focusout","[name=value18]", function(){
			var idx = $("[name=value18]").index(this);
			var value18 = $("[name=value18]").eq(idx).val();
			var removeCommaValue18 = value18.replaceAll(',','');
			$("[name=value18]").eq(idx).val(removeCommaValue18);
	}); 
	
	$(document).on("focusout","[name=value19]", function(){
			var idx = $("[name=value19]").index(this);
			var value19 = $("[name=value19]").eq(idx).val();
			var removeCommaValue19 = value19.replaceAll(',','');
			$("[name=value19]").eq(idx).val(removeCommaValue19);
	}); 
	
	$(document).on("focusout","[name=value20]", function(){
			var idx = $("[name=value20]").index(this);
			var value20 = $("[name=value20]").eq(idx).val();
			var removeCommaValue20 = value20.replaceAll(',','');
			$("[name=value20]").eq(idx).val(removeCommaValue20);
	}); 
	
	$(document).on("focusout","[name=value21]", function(){
			var idx = $("[name=value21]").index(this);
			var value21 = $("[name=value21]").eq(idx).val();
			var removeCommaValue21 = value21.replaceAll(',','');
			$("[name=value21]").eq(idx).val(removeCommaValue21);
	}); 


</script>
<style>
	.comp_amt_pl{
		color:blue;
	}
	.comp_amt_mi{
		color:red;
	}
</style>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
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
  <input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_new_frame.jsp'>
  <input type='hidden' name='reg_code' value=''>
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='size' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='4350'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='510' id='td_title' style='position: sticky;left: 0;z-index: 1;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='50' class='title' style='height:51'>연번</td>
		    <td width='50' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td width='50' class='title'>점검</td>
		    <td width='100' class='title'>보험사</td>
		    <td width='50' class='title'>상태</td>
        <td width='80' class='title'>등록일</td>
		    <td width="50" class='title'>등록자</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='3840'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="20" class='title'>요청</td>
		    <td colspan="17" class='title'>결과</td>
		</tr>
		<tr>
		    <td width='4%' class='title'>고객</td>
		    <td width='4%' class='title'>상호(보험사용)</td>
		    <td width='2%' class='title'>고객구분</td>
		    <td width='3%' class='title'>사업자번호</td>
		    <td width='2%' class='title'>용도</td>
		    <td width='4%' class='title'>차명</td>
		    <td width='2%' class='title'>승차정원</td>
		    <td width='2%' class='title'>차량번호</td>	
		    <td width='4%' class='title'>차대번호</td>
		    <td width='3%' class='title'>차량소비자가</td>
		    <td width='2%' class='title'>운전자연령</td>
		    <td width='2%' class='title'>대물배상</td>	
		    <td width='2%' class='title'>자기신체<br>사고</td>
		    <td width='2%'  class='title'>임직원전용</td>
		    <td width='2%'  class='title'>차선(제어)</td>
		    <td width='2%'  class='title'>차선(경고)</td>
		    <td width='2%'  class='title'>긴급(제어)</td>
		    <td width='2%'  class='title'>긴급(경고)</td>
		    <td width='2%'  class='title'>전기차</td>
		    <td width='2%'  class='title'>견인고리</td>
		    <td width='2%'  class='title'>법률비용<br>지원금</td>
		    
		    <td width='4%' class='title'>블랙박스</td>	
		    <td width='2%' class='title'>가격<br>(공급가)</td>
		    <td width='4%' class='title'>시리얼번호</td>
		    <%if(gubun1.equals("0007")){%>
		    	<td width='3%' class='title'>개발원코드</td>
		    <%}%>
		    <td width='4%' class='title'>증권번호</td>
		    <td width='3%' class='title'>차량번호</td>
		    <td width='2%' class='title'>대인배상</td>
		    <td width='2%' class='title'>대인배상</td>
		    <td width='2%' class='title'>대물배상</td>
		    <td width='2%' class='title'>자기신체<br>사고</td>
		    <td width='2%' class='title'>무보험차<br>상해</td>
		    <td width='2%' class='title'>분담금<br>할증한정</td>
		    <td width='2%' class='title'>자기차량<br>손해</td>
		    <td width='2%' class='title'>긴급출동</td>
		    <td width='2%' class='title'>총보험료</td>
		    <td width='2%' class='title'>임직원<br>전용보험</td>
		    <td width='7%' class='title'>비고</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' width='510' id='td_con' style='position: sticky;left: 0;z-index: 1;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
		%>
		<tr>
		    <td width='50' align='center'><%=i+1%></td>
		    <td width='50' align='center'>
		    	<%if(String.valueOf(ht.get("USE_ST")).equals("등록") || String.valueOf(ht.get("USE_ST")).equals("요청") ||String.valueOf(ht.get("USE_ST")).equals("확인")){%>
		    	<input type="checkbox" name="ch_cd" class="ch_cd" value="<%=ht.get("REG_CODE")%>/<%=ht.get("SEQ")%>/<%=i%>">
		    	<%}%>
		    </td>
		    <td width='50' align='center'><input type='text' name='chk_cont' size='3' class='whitetext' value=''></td>
		    <td width='100' align='center'><span title='<%=ht.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("INS_COM_NM")), 7)%></span></td>
		    <td width='50' align='center'><%=ht.get("USE_ST")%></td>
		    <td width='80' align='center'><%=ht.get("REG_DT2")%></td>
		    <td width='50' align='center'><span title='<%=ht.get("REG_NM")%>'><%=Util.subData(String.valueOf(ht.get("REG_NM")), 3)%></span></td>
		</tr>
		<%	}%>
	    </table>
	</td>
	<td class='line' width='3840'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				int rins_pcp = 0;
				int vins_pcp = 0;
				int vins_gcp = 0;
				int vins_bacdt = 0;
				int vins_canoisr = 0;
				int vins_share = 0;
				int total_amt = 0;
				
				// 첨단안전장치 유무와 전기차 유무에 따른 할인율 적용
				double discountPer = 0;
				String val28 = String.valueOf(ht.get("VALUE28")); // 차선(제어)
				String val29 = String.valueOf(ht.get("VALUE29")); // 차선(경고)
				String val30 = String.valueOf(ht.get("VALUE30")); // 긴급(제어)
				String val31 = String.valueOf(ht.get("VALUE31")); // 긴급(경고)
				String val32 = String.valueOf(ht.get("VALUE32")); // 전기차 여부
				
				
				// 첨단안전장치 전체 가입시 최대 6% 적용
				if(val28.equals("Y") && val29.equals("Y") && val30.equals("Y") && val31.equals("Y") && val32.equals("Y")) {
					discountPer = 6;
				// 첨단안전장치 전체 가입이 아닌 경우
				} else {
					// 차선(제어), 차선(경고) 유무에 따른 할인 적용
					if(val28.equals("Y") && val29.equals("Y")) {
						discountPer = discountPer + 4;
					} else if(val28.equals("Y") && val29.equals("N")) {
						discountPer = discountPer + 4;
					} else if(val28.equals("N") && val29.equals("Y")) {
						discountPer = discountPer + 2.5;
					}
					// 긴급제동(제어), 긴급제동(경고) 유무에 따른 할인 적용					
					if(val30.equals("Y") && val31.equals("Y")) {
						discountPer = discountPer + 2;
					} else if(val30.equals("Y") && val31.equals("N")) {
						discountPer = discountPer + 2;
					} else if(val30.equals("N") && val31.equals("Y")) {
						discountPer = discountPer + 1;
					}
					
					// 전기차 할인률 적용 여부
					if(val32.equals("Y")) {
						discountPer = discountPer + 3;
					}
					
					// 총 할인률의 합이 6%가 넘을 경우 최대 6% 적용	
					if(discountPer > 6) {
						discountPer = 6;
					}
				}
				
				// 할인률 적용
				if(discountPer != 0.0 || discountPer != 0 ) {
					discountPer = discountPer * 0.01;
					
				} else {
					discountPer = 0;
				}
				
				if(gubun2.equals("확인") || gubun2.equals("완료")){
					Hashtable cp = ic_db.getCompareAmt(String.valueOf(ht.get("CAR_KD")),String.valueOf(ht.get("INS_COM_NM")),String.valueOf(ht.get("AGE_SCP")),String.valueOf(ht.get("VINS_GCP_KD")),"미가입",String.valueOf(ht.get("COM_EMP_YN")), discountPer);
					
					if(ht.get("VALUE17") != null && cp.get("RINS_PCP_AMT") != null &&
						!String.valueOf(ht.get("VALUE17")).equals("") && !String.valueOf(cp.get("RINS_PCP_AMT")).equals("")	
					){
						rins_pcp = Integer.parseInt(String.valueOf(ht.get("VALUE17")))-Integer.parseInt(String.valueOf(cp.get("RINS_PCP_AMT")));
					}
					
					if(ht.get("VALUE18") != null && cp.get("VINS_PCP_AMT") != null &&
							!String.valueOf(ht.get("VALUE18")).equals("") && !String.valueOf(cp.get("VINS_PCP_AMT")).equals("")	
					){
						vins_pcp = Integer.parseInt(String.valueOf(ht.get("VALUE18")))-Integer.parseInt(String.valueOf(cp.get("VINS_PCP_AMT")));
					}
					
					if(ht.get("VALUE19") != null && cp.get("VINS_GCP_AMT") != null &&
							!String.valueOf(ht.get("VALUE19")).equals("") && !String.valueOf(cp.get("VINS_GCP_AMT")).equals("")	
					){
						vins_gcp = Integer.parseInt(String.valueOf(ht.get("VALUE19")))-Integer.parseInt(String.valueOf(cp.get("VINS_GCP_AMT")));
					}
					
					if(ht.get("VALUE20") != null && cp.get("VINS_BACDT_AMT") != null &&
							!String.valueOf(ht.get("VALUE20")).equals("") && !String.valueOf(cp.get("VINS_BACDT_AMT")).equals("")	
					){
						vins_bacdt = Integer.parseInt(String.valueOf(ht.get("VALUE20")))-Integer.parseInt(String.valueOf(cp.get("VINS_BACDT_AMT")));
					}
					
					if(ht.get("VALUE21") != null && cp.get("VINS_CANOISR_AMT") != null &&
							!String.valueOf(ht.get("VALUE21")).equals("") && !String.valueOf(cp.get("VINS_CANOISR_AMT")).equals("")	
					){
						vins_canoisr = Integer.parseInt(String.valueOf(ht.get("VALUE21")))-Integer.parseInt(String.valueOf(cp.get("VINS_CANOISR_AMT")));
					}
					
					if(ht.get("VALUE22") != null && cp.get("VINS_SHARE_EXTRA_AMT") != null &&
							!String.valueOf(ht.get("VALUE22")).equals("") && !String.valueOf(cp.get("VINS_SHARE_EXTRA_AMT")).equals("")	
					){
						vins_share = Integer.parseInt(String.valueOf(ht.get("VALUE22")))-Integer.parseInt(String.valueOf(cp.get("VINS_SHARE_EXTRA_AMT")));
					}
					if(ht.get("VALUE25") != null && cp.get("TOTAL_AMT") != null &&
							!String.valueOf(ht.get("VALUE25")).equals("") && !String.valueOf(cp.get("TOTAL_AMT")).equals("")	
					){
						total_amt = Integer.parseInt(String.valueOf(ht.get("VALUE25")))-Integer.parseInt(String.valueOf(cp.get("TOTAL_AMT")));
					}
				}
				
				%>			
		<tr>
		        <td width='4%' align='center'><span title='<%=ht.get("VALUE01")%>'><%=Util.subData(String.valueOf(ht.get("VALUE01")), 10)%></span></td>
		        <td width='4%' align='center'><span title='<%=ht.get("VALUE33")%>'><%=Util.subData(String.valueOf(ht.get("VALUE33")), 10)%></span></td>
		        <td width='2%' align='center'><%=ht.get("VALUE35")%></td>
		        <td width='3%' align='center'><%=ht.get("VALUE02")%></td>
		        <td width='2%' align='center'><%=ht.get("VALUE34")%></td>
		        <td width='4%' align='center'><a href="javascript:parent.view_ins_com('<%=ht.get("REG_CODE")%>', '<%=ht.get("SEQ")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><span title='<%=ht.get("VALUE03")%>'><%=Util.subData(String.valueOf(ht.get("VALUE03")), 10)%></span></a></td>
		        <td width='2%'  align='center'><%=ht.get("JG_G_CODE")%></td>
		        <td width='2%' align='center'><%=ht.get("VALUE04")%></td>
		        <td width='4%' align='center'><%=ht.get("VALUE05")%></td>
		        <td width='3%' align='right'><%=ht.get("VALUE06")%></td>
		        <td width='2%' align='center'><%=ht.get("VALUE07")%></td>
		        <td width='2%' align='center'><%=ht.get("VALUE08")%></td>
		        <td width='2%' align='center'><%=ht.get("VALUE09")%></td>
		        <td width='2%'  align='center'><%=ht.get("VALUE10")%></td>
		        <td width='2%'  align='center'><%=ht.get("VALUE28")%></td>
		        <td width='2%'  align='center'><%=ht.get("VALUE29")%></td>
		        <td width='2%'  align='center'><%=ht.get("VALUE30")%></td>
		        <td width='2%'  align='center'><%=ht.get("VALUE31")%></td>
		        <td width='2%'  align='center'><%=ht.get("VALUE32")%></td>
		        <td width='2%'  align='center'><%=ht.get("VALUE37")%></td>
		        <td width='2%'  align='center'><%=ht.get("VALUE38")%></td>
		        
		        <td width='4%' align='center'><span title='<%=ht.get("VALUE11")%>'><%=Util.subData(String.valueOf(ht.get("VALUE11")), 10)%></span></td>
		        <td width='2%' align='right'><%=ht.get("VALUE12")%></td>
		        <td width='4%' align='center'><%=ht.get("VALUE13")%></td>
		        <%if(gubun1.equals("0007") && !gubun2.equals("요청")){%>
		        <td width='3%' align='center'><%=ht.get("INSUR_CODE")%></td>
		        <%} else if( gubun1.equals("0007") && gubun2.equals("요청")) {%>
		        <td width='3%' align='center'><input type="text" name="insur_code" class="insur_code" style="width:80%; text-align:center;" value="<%=ht.get("INSUR_CODE")%>"/></td>
		        <%} %>
		        <%if(gubun1.equals("0007") && !gubun2.equals("요청")) {%>
		        	<td width='4%' align='center'><%=ht.get("VALUE15")%></td>
		        <%} else if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='4%' align='center'><input name="value15" class="value15" type="text" style="width:80%; text-align:center;" value="<%=ht.get("VALUE15")%>"/></td>
		        <%} else if(!gubun1.equals("0007")) {%>
		        	<td width='4%' align='center'><%=ht.get("VALUE15")%></td>
		        <%} %>
		        
		        <td width='3%' align='center'><%=ht.get("VALUE16")%></td>
		        
		         <%if(gubun1.equals("0007") && !gubun2.equals("요청")) {%>
		        	<td width='2%' align='right'>
				        <%if(rins_pcp>0){%><span class="comp_amt_pl">+<%=rins_pcp%></span> 
				        <%}else if(rins_pcp<0){%><span class="comp_amt_mi"><%=rins_pcp%></span>
			         	<%}%> 
				        <%=ht.get("VALUE17")%>
				    </td>
		        <%} else if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='2%' align='center'><input name="value17" class="value17" type="text" style="width:80%; text-align:right;" value="<%=ht.get("VALUE17")%>"/></td>
		        <%} else if(!gubun1.equals("0007")) {%>
		        	<td width='2%' align='right'>
				        <%if(rins_pcp>0){%><span class="comp_amt_pl">+<%=rins_pcp%></span> 
				        <%}else if(rins_pcp<0){%><span class="comp_amt_mi"><%=rins_pcp%></span>
			         	<%}%> 
				        <%=ht.get("VALUE17")%>
				    </td>
		        <%} %>
		        
		         <%if(gubun1.equals("0007") && !gubun2.equals("요청")) {%>
		        	<td width='2%' align='right'>
				        <%if(vins_pcp>0){%><span class="comp_amt_pl">+<%=vins_pcp%></span>
				        <%}else if(vins_pcp<0){%><span class="comp_amt_mi"><%=vins_pcp%></span>
				        <%}%>
				        <%=ht.get("VALUE18")%>
		        	</td>
		        <%} else if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='2%' align='center'><input name="value18" class="value18" type="text" style="width:80%; text-align:right;" value="<%=ht.get("VALUE18")%>"/></td>
		        <%} else if(!gubun1.equals("0007")) {%>
		        	<td width='2%' align='right'>
				        <%if(vins_pcp>0){%><span class="comp_amt_pl">+<%=vins_pcp%></span>
				        <%}else if(vins_pcp<0){%><span class="comp_amt_mi"><%=vins_pcp%></span>
				        <%}%>
				        <%=ht.get("VALUE18")%>
		        	</td>
		        <%} %>
		        
		         <%if(gubun1.equals("0007") && !gubun2.equals("요청")) {%>
		        	<td width='2%' align='right'>
				        <%if(vins_gcp>0){%><span class="comp_amt_pl">+<%=vins_gcp%></span>
				        <%}else if(vins_gcp<0){%><span class="comp_amt_mi"><%=vins_gcp%></span>
				        <%}%>
				        <%=ht.get("VALUE19")%>
				    </td>
		        <%} else if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='2%' align='center'><input name="value19" class="value19" type="text" style="width:80%; text-align:right;" value="<%=ht.get("VALUE19")%>"/></td>
		        <%} else if(!gubun1.equals("0007")) {%>
		        	<td width='2%' align='right'>
				        <%if(vins_gcp>0){%><span class="comp_amt_pl">+<%=vins_gcp%></span>
				        <%}else if(vins_gcp<0){%><span class="comp_amt_mi"><%=vins_gcp%></span>
				        <%}%>
				        <%=ht.get("VALUE19")%>
				    </td>
		        <%} %>
		        
		         <%if(gubun1.equals("0007") && !gubun2.equals("요청")) {%>
		        	<td width='2%' align='right'>
				        <%if(vins_bacdt>0){%><span class="comp_amt_pl">+<%=vins_bacdt%></span>
				        <%}else if(vins_bacdt<0){%><span class="comp_amt_mi"><%=vins_bacdt%></span>
				        <%}%>
		        		<%=ht.get("VALUE20")%>
		        	</td>
		        <%} else if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='2%' align='center'><input name="value20" class="value20" type="text" style="width:80%; text-align:right;" value="<%=ht.get("VALUE20")%>"/></td>
		        <%} else if(!gubun1.equals("0007")) {%>
		        	<td width='2%' align='right'>
				        <%if(vins_bacdt>0){%><span class="comp_amt_pl">+<%=vins_bacdt%></span>
				        <%}else if(vins_bacdt<0){%><span class="comp_amt_mi"><%=vins_bacdt%></span>
				        <%}%>
		        		<%=ht.get("VALUE20")%>
		        	</td>
		        <%} %>
		        
		         <%if(gubun1.equals("0007") && !gubun2.equals("요청")) {%>
		        	<td width='2%' align='right'>
				        <%if(vins_canoisr>0){%><span class="comp_amt_pl">+<%=vins_canoisr%></span>
				        <%}else if(vins_canoisr<0){%><span class="comp_amt_mi"><%=vins_canoisr%></span>
				        <%}%>
				        <%=ht.get("VALUE21")%>
		        	</td>
		        <%} else if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='2%' align='center'><input name="value21" class="value21" type="text" style="width:80%; text-align:right;" value="<%=ht.get("VALUE21")%>"/></td>
		        <%} else if(!gubun1.equals("0007")) {%>
		        	<td width='2%' align='right'>
				        <%if(vins_canoisr>0){%><span class="comp_amt_pl">+<%=vins_canoisr%></span>
				        <%}else if(vins_canoisr<0){%><span class="comp_amt_mi"><%=vins_canoisr%></span>
				        <%}%>
				        <%=ht.get("VALUE21")%>
		        	</td>
		        <%} %>
		        
		        
		        <td width='2%' align='right'>
		        <%if(vins_share>0){%><span class="comp_amt_pl">+<%=vins_share%></span>
		        <%}else if(vins_share<0){%><span class="comp_amt_mi"><%=vins_share%></span>
		        <%}%>
		        <%=ht.get("VALUE22")%></td>
		        <td width='2%' align='right'><%=ht.get("VALUE23")%></td>
		        <td width='2%' align='right'><%=ht.get("VALUE24")%></td>
		        <td width='2%' align='right'>
		         <%if(total_amt>0){%><span class="comp_amt_pl">+<%=total_amt%></span>
		         <%}else if(total_amt<0){%><span class="comp_amt_mi"><%=total_amt%></span>
		         <%}%>
		        <%=ht.get("VALUE25")%></td>
		        
<%-- 		        <%if(gubun1.equals("0007") && !gubun2.equals("요청")) {%> --%>
<%-- 		        	<td width='2%' align='center'><%=ht.get("VALUE26")%></td> --%>
<%-- 		        <%} else if(gubun1.equals("0007") && gubun2.equals("요청")) {%> --%>
<!-- 		       	 	<td width='2%' align='center'> -->
<!-- 			        	<select name="value26" class="value26"> -->
<%-- 							<option value="N" <%if(ht.get("VALUE26").equals("") || ht.get("VALUE26").equals("N")) { %> --%>
<%-- 													selected<%} %> >미가입</option> --%>
<%-- 							<option value="Y" <%if(ht.get("VALUE26").equals("Y")) {%> --%>
<%-- 							   				  	selected<%} %>>가입</option>		        	 --%>
<!-- 			        	</select> -->
<!-- 		        	</td> -->
<%-- 		        <%} else if(!gubun1.equals("0007")) {%> --%>
<%-- 		        	<td width='2%' align='center'><%=ht.get("VALUE26")%></td> --%>
<%-- 		        <%} %> --%>
		        <td width='2%' align='center'><%=ht.get("VALUE26")%></td>
		        <td width='7%'>&nbsp;<%=ht.get("ETC")%></td>
		        <input type="hidden" style="display:none" id="save_yn" name="save_yn" class="save_yn" value="<%=ht.get("SAVE_YN")%>"/>
		        <input type="hidden" style="display:none" id="reg_code" name="reg_code" class="reg_code" value="<%=ht.get("REG_CODE")%>"/>
		        <input type="hidden" style="display:none" id="seq" name="seq" class="seq" value="<%=ht.get("SEQ")%>"/>
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <tr>
	<td class='line' width='510' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='3840'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%>
</table>
</form>
<form name='form2' method='post' style="display:none">
	<input type="hidden" value="" id="insurCodeArray" name="insurCodeArray"/>
	<input type="hidden" value="" id="value15Array" name="value15Array"/>
	<input type="hidden" value="" id="value17Array" name="value17Array"/>
	<input type="hidden" value="" id="value18Array" name="value18Array"/>
	<input type="hidden" value="" id="value19Array" name="value19Array"/>
	<input type="hidden" value="" id="value20Array" name="value20Array"/>
	<input type="hidden" value="" id="value21Array" name="value21Array"/>
	<input type="hidden" value="" id="value26Array" name="value26Array"/>
	<input type="hidden" value="" id="arraySize" name="arraySize"/>
	<input type="hidden" value="" id="regCodeArray" name="regCodeArray"/>
	<input type="hidden" value="" id="seqArray" name="seqArray"/>
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
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

