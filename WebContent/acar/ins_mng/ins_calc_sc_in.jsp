<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
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
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
		
	Vector vt = ai_db.getInsCalcList(gubun2, gubun3, st_dt, end_dt, s_kd, t_wd );
	int vt_size = vt.size();
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src='/include/common.js'></script>
<script>

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
		var len = fm.ch_cd.length;
		var cnt = 0;
		var idnum ="";
		var allChk = fm.ch_all;
		 for(var i=0; i<len; i++){
			var ck = fm.ch_cd[i];
			if(allChk.checked == false){
				ck.checked = false;
			}else{
				ck.checked = true;
			}
		} 
		return;
	}	
	
	function selectOne(reg_code){
		parent.parent.location.href = '/acar/ins_mng/ins_calc_reg.jsp?reg_code='+reg_code;
	}
	
	function regInsCost(reg_code, ins_cost){
		var fm = document.form1;
		location.href = '/acar/ins_mng/ins_calc_reg_a.jsp?reg_code='+reg_code+'&req_st=c&ins_cost='+ins_cost;
	}
	
	function regInsCostBtn(reg_code, k){
		var fm = document.form1;
		var vt_size = '<%=vt_size%>';
		var ins_cost = "";
		if(vt_size == 1) 
			ins_cost = fm.ins_cost.value;
		else 
			ins_cost = fm.ins_cost[k].value;
		
		regInsCost(reg_code, ins_cost);	
	}
	
	function sendconfirm(reg_code, ins_cost, car_name, reg_id){
		var req_st ='f';
		if(confirm("완료 하시겠습니까?") == true){
			var fm = document.form1;
			parent.parent.location.href = '/acar/ins_mng/ins_calc_reg_a.jsp?reg_code='+reg_code+'&req_st='+req_st+'&car_name2='+car_name+'&reg_id='+reg_id+'&ins_cost='+ins_cost;
		}else{
			return;			
		}
	}
	
	function onKeyDown(reg_code, ins_cost){
		regInsCost(reg_code, ins_cost);	
	}
	
	function onlyNumber(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		
	}
	function removeChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}
	function numberComma(x){
		var fm = document.form1;
		fm.ins_cost.value= x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

</script>
</head>
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
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='size' value=''>
  <input type='hidden' name='req_st' value=''>

  <br>
<table border="0" cellspacing="0" cellpadding="0" width='1800'>
     <tr>
        <td colspan="2" class=line2></td>
    </tr> 
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='240' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
		<tr>
		    <td width='30' class='title'></td>
		    <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
        	<td width='80' class='title'>등록일</td>
		    <td width="50" class='title'>등록자</td>
		    <td width="50" class='title'>구분</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1470'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
		<tr>
		    <td width='130' class='title'>차종</td>
		    <td width='100' class='title'>차량가격</td>
		    <td width='130' class='title'>고객</td>
		    <td width='90' class='title'>직업</td>
		    <td width='100' class='title'>사업자번호</td>
		    <td width='100' class='title'>주민등록번호</td>
		    <td width='100' class='title'>휴대폰번호</td>
		    <td width='80' class='title'>연령</td>
		    <td width='60' class='title'>대물</td>
		    <td width='70' class='title'>한정</td>
		    <td width='60' class='title'>임직원</td>
		    <td width='100' class='title'>운전자이름</td>
		    <td width='100' class='title'>운전자생년월일</td>
		    <td width='70' class='title'>운전자관계</td>
		    <td width='80' class='title'>보험료공급가</td>
		    <%if(!gubun2.equals("완료")){ %>
		    <td width='50' class='title'>저장</td>
		    <td width='50' class='title'>확인</td>
		    <%} %>
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' width='240' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(acar_de.equals("1000") && !ck_acar_id.equals(String.valueOf(ht.get("REG_ID")))){
					continue;
				}
		%>
		<tr>
		    <td width='30' align='center'><%=count+1%></td>
		    <td width='30' align='center'><input type="checkbox" name="ch_cd" value=""></td>
		    <td width='80' align='center'><%=ht.get("REG_DT")%></td>
		    <td width='50' align='center'><%=ht.get("USER_NM")%></td>
		    <td width='50' align='center'><%=ht.get("CLIENT_ST_NM")%></td>
		</tr>
		<%	}%>
	    </table>
	</td>
	<td class='line' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(acar_de.equals("1000") && !ck_acar_id.equals(String.valueOf(ht.get("REG_ID")))){
					continue;
				}
		%>			
		<tr>
		        <td width='130' align='center'><%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 10)%></td>
		        <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CAR_B_P")))%>&nbsp;원&nbsp;</td>
		        <td width='130' align='center'><a href="javascript:selectOne('<%=ht.get("REG_CODE")%>');"><%=Util.subData(String.valueOf(ht.get("CLIENT_NM")), 10)%></a></td>
		        <td width='90' align='center'><%=Util.subData(String.valueOf(ht.get("JOB")), 10)%></td>
		        <td width='100' align='center'><%=ht.get("ENP_NO")%></td>
		        <td width='100' align='center'><%=ht.get("SSN")%></td>
		        <td width='100' align='center'><%=ht.get("M_TEL")%></td>
		        <td width='80' align='center'><%=ht.get("AGE_SCP")%></td>
		        <td width='60' align='center'><%=ht.get("VINS_GCP_KD")%></td>
		        <td width='70' align='center'><%=ht.get("INS_LIMIT")%></td>
		        <td width='60' align='center'><%=ht.get("COM_EMP_YN")%></td>
		        <td width='100' align='center'><%=ht.get("DRIVER_NM")%></td>
		        <td width='100' align='center'><%=ht.get("DRIVER_SSN")%></td>
		        <td width='70' align='center'><%=Util.subData(String.valueOf(ht.get("DRIVER_REL")), 5)%></td>
				<%if(!ht.get("USE_ST").equals("완료")){ %>
				 	<td width='80' align='center'><input type="text" name="ins_cost" value="<%=Util.parseDecimal(String.valueOf(ht.get("INS_COST")))%>" size="6" tabindex="<%=i+1%>" onkeypress="if(event.keyCode==13)javascript:onKeyDown('<%=ht.get("REG_CODE")%>',this.value)"
		        								onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' onblur='numberComma(this.value)'>
					</td>
					<td width='50' align='center'><a href="javascript:regInsCostBtn('<%=ht.get("REG_CODE")%>','<%=i%>');" title='저장' ><img src=/acar/images/center/button_save.gif border=0></a></td>
		        <td width='50' align='center'><a href="javascript:sendconfirm('<%=ht.get("REG_CODE")%>','<%=ht.get("INS_COST")%>','<%=ht.get("CAR_NAME")%>','<%=ht.get("REG_ID")%>');" title='확인' ><img src=/acar/images/center/button_conf.gif border=0></a></td>
				<%}else{ %>
					<td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("INS_COST")))%>&nbsp;원&nbsp;</td>
				<%} %>
		        
				<input type='hidden' name='reg_code' value='<%=ht.get("REG_CODE")%>'>
		</tr>
		<% count++;%>		
		<%	}%>
	    </table>
	</td>
    </tr>
    <%	}%>
    <%if(count == 0){ %>   
    <tr>
	<td class='line' width='400' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1470'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%>
    <tr>
        <td colspan="2" class=line2></td>
    </tr> 
</table>
<div style="height: 100px;"></div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script>
	parent.document.form1.size.value = '<%=count%>';
</script>
</body>
</html>

