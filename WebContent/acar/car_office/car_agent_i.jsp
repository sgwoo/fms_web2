<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.bill_mng.*, acar.user_mng.*" %>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String st 	= request.getParameter("st")==null?"":request.getParameter("st");
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//은행 리스트
	CodeBean cd_r [] = c_db.getCodeAllCms("0003");
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function CarOffReg(){
		var theForm = document.form1;
		if(!CheckField()){
			return;
		}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "i";
		theForm.target = "i_no"
		theForm.submit();
	}

	function search_zip()
	{
		window.open("./zip_s.jsp", "우편번호검색", "left=100, top=100, width=400, height=500, scrollbars=yes");
	}

	function CheckField()
	{
		var theForm = document.form1;
		if(theForm.car_off_nm.value	=="")	{		alert("영업소명를 입력하십시요.");		theForm.car_off_nm.focus();		return false;	}
		if(theForm.car_off_tel.value	=="")	{		alert("사무실전화번호를 입력하십시요.");	theForm.car_off_tel.focus();		return false;	}		
		return true;
	}
	
	function go_list(){
		location.href = "./car_agent_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&s_kd=<%= s_kd %>&t_wd=<%= t_wd %>";
	}

	//네오엠 조회하기
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=400, scrollbars=yes");		
	}		
	
	//지급관리
	function cng_input2(){
		if(document.form1.work_st[0].checked==true){tr_pay_way.style.display='';}
		else{tr_pay_way.style.display='none';}
	}	
//-->
</script>
</head>
<body>
<form action="./car_agent_null_ui.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="cmd" value="">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > 에이전트관리 > <span class=style5>에이전트등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td align=right>
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
            <a href="javascript:CarOffReg()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
            <%}%>
	    <a href="javascript:go_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>			    	
                    <td width=12% class=title>관리구분</td>
		    <td width=20%>&nbsp;
		        <input type="radio" name="car_off_st" value="3" >법인&nbsp;
                    	<input type="radio" name="car_off_st" value="4" >개인사업자
		    </td>			    	
		    <td width=12% class=title>소속구분</td>
                    <td width=24%>&nbsp;
                    	<input type="radio" name="agent_st" value="1" >에이전트&nbsp;
                    	<input type="radio" name="agent_st" value="2" >프리랜서
                    </td>
                    <td class=title width=12%>최초등록일</td>
                    <td width=20%>&nbsp;
                        <%=AddUtil.getDate()%><input type="hidden" name="reg_dt" value="<%=AddUtil.getDate()%>"></td>                    
		</tr>
            	<tr>			    	
                    <td width=12% class=title>업무구분</td>
					<td>&nbsp;
							 <input type="radio" name="work_st" value="C"  onClick="javascript:cng_input2()">견적,계약 모두&nbsp;&nbsp;
                    		 <input type="radio" name="work_st" value="E" onClick="javascript:cng_input2()">견적만
					</td>
					<td width=12% class=title>거래구분</td>
					<td colspan='3'>&nbsp;
							 <input type="radio" name="use_yn" value="Y" Checked="true" >거래&nbsp;&nbsp;
                    		 <input type="radio" name="use_yn" value="N" >미거래
					</td>
		</tr>		
                <tr>                    
                    <td class=title>상호/성명</td>
		    <td>&nbsp;
		        <input type="text" name="car_off_nm" value="" size="20" class=text></td>			    	
                    <td class=title>사업자구분</td>
               	    <td>&nbsp;
                    	<input type="radio" name="enp_st" value="1" >개인&nbsp;
                    	<input type="radio" name="enp_st" value="2" >법인&nbsp;   
                    </td>
               	    <td class=title>사업자/주민번호</td>
               	    <td>&nbsp;
               	        <input type="text" name="enp_no" value="" size="20" class=text></td>                    
                </tr>		
                <tr>                    
                    <td class=title>대표자</td>
		    <td>&nbsp;
		        <input type="text" name="owner_nm" value="" size="20" class=text></td>			    	
                    <td class=title>대표전화</td>
               	    <td>&nbsp;
               	        <input type="text" name="car_off_tel" value="" size="20" class=text></td>
               	    <td class=title>팩스</td>
               	    <td>&nbsp;
               	        <input type="text" name="car_off_fax" value="" size="20" class=text></td>                    
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
								function openDaumPostcode() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('car_off_post').value = data.zonecode;
											document.getElementById('car_off_addr').value = data.address;
											
										}
									}).open();
								}
				</script>							
				<tr>
					<td class=title>주소</td>
					<td colspan=5>&nbsp;
					<input type="text" name='car_off_post' id="car_off_post" value="" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='car_off_addr' id="car_off_addr" value="" size="100">

				</tr>
 
            </table>
        </td>
    </tr>    
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr id=tr_pay_way style="display:''">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>			    	
                    <td width=12% class=title>사업자등록구분</td>
		    <td width=20%>&nbsp;
		        <input type="radio" name="enp_reg_st" value="1" >사업자등록사업자<br>&nbsp;
                    	<input type="radio" name="enp_reg_st" value="2" >사업자미등록자
		    </td>			    	
		    <td width=12% class=title>거래증빙</td>
                    <td width=24%>&nbsp;
                    	<input type="radio" name="doc_st" value="1" >원천징수&nbsp;
                    	<input type="radio" name="doc_st" value="2" >세금계산서
                    </td>
                    <td class=title width=12%>수수료지급</td>
                    <td width=20%>&nbsp;
                    	<input type="radio" name="est_day" value="C" >개별&nbsp;
                    	<input type="radio" name="est_day" value="D" >매월
                    	<input type="text" name="est_day_sub" value="00" size="2" class=text>일
                    	<input type="hidden" name="est_mon_st" value="1">
                    	<!--
                    	(
                    	<select name="est_mon_st">
                        <option value="">선택</option>
            		        <option value="1">익월</option>
            		        <option value="0">당월</option>
                      </select>
                    	)
                    	-->
                    </td>
		</tr>                                            
                <tr>
                    <td class=title>거래처명<br>/코드(회계)</td>
               	    <td>&nbsp;
               	        <!--
               	        <input type='text' name='ven_name' size='20' value='' class='text' style='IME-MODE: active'>
			<a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a><br>&nbsp;
			<img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <input type='text' name='ven_code' size='5' value='' class='text'>						
			-->
               	    </td>
               	    <td class=title>세금계산서<br>수취구분</td>
               	    <td>&nbsp;
		        <input type="radio" name="req_st" value="1" >개별&nbsp;
                    	<input type="radio" name="req_st" value="2" >월합&nbsp;
                    	<input type="radio" name="req_st" value="3" >없음
		    </td>			
               	    <td class=title>지급구분</td>
               	    <td>&nbsp;
		        <input type="radio" name="pay_st" value="1" >월합&nbsp;
                    	<input type="radio" name="pay_st" value="2" >개별건별&nbsp;                    	
		    </td>			
                </tr>                     
                <tr>
                    <td class=title>거래은행</td>
               	    <td>&nbsp;
               	    	<input type='hidden' name="bank" 			value="">
		        <select name="bank_cd">
			    <option value="">선택</option>
			    <%for(int i=0; i<cd_r.length; i++){
        				cd_bean = cd_r[i];
        				//신규인경우 미사용은행 제외
								if(cd_bean.getUse_yn().equals("N"))	 continue;
        				%>
            		    <option value="<%= cd_bean.getCode() %>"><%= cd_bean.getNm() %></option>
                            <%}%>
                        </select>					
               	    </td>
               	    <td class=title>계좌번호</td>
               	    <td>&nbsp;
               	        <input type="text" name="acc_no" value="" size="20" class=text></td>
               	    <td class=title>예금주</td>
               	    <td>&nbsp;
               	        <input type="text" name="acc_nm" value="" size="20" class=text></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
