<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
 	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dest_gubun= request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");
	String send_dt 	= request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String s_bus 	= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String cmid		= request.getParameter("cmid")==null?"":request.getParameter("cmid");
	String cmst		= request.getParameter("cmst")==null?"":request.getParameter("cmst");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Hashtable ht = umd.getSmsV5(cmid, cmst);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "SMS");
	int user_size = users.size();
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//단기대여---------------------------------------------------------------------------------------------------------
	
	//고객 조회
	function cust_select(){
		var fm = document.form1;
		window.open("search_client.jsp?s_kd=1&t_wd="+fm.firm_nm.value, "CLIENT_SEARCH", "left=50, top=50, width=820, height=450, status=yes");
	}	
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') cust_select();
	}	
	
	//문자 보내기
	function SandSms(){
		var fm = document.form1;			
		if(fm.destname.value == '')	{ alert('수신자를 입력하십시오.'); 		return; }
		
		if(fm.no_num.checked){
		
		}else{
			if(fm.destphone.value == ''){ alert('수신번호를 입력하십시오.'); 	return; }
		}
		
		if(fm.key_nice.value != '' || fm.key_kcb.value != ''){
			if(fm.key_name.value == '')	{ alert('성명을 선택하십시오.'); 		return; }
			if(fm.birth_dt.value == '')	{ alert('생년월일을 선택하십시오.'); 		return; }			
			
			if(fm.birth_dt.value.length < 6 || fm.birth_dt.value.length > 6)		{ alert('생년월일(YYMMDD)을 확인하십시오.'); 	return;}		
		}
		
		if(confirm('신용조회 이력을 등록하시겠습니까?'))				
		{				
			fm.action = "v5_sms_cre_i_a2.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}
	}	
	
	function search_eval_key(){
		var fm = document.form1;
		window.open("/fms2/lc_rent/search_eval_key.jsp?from_page=/acar/sms_gate/v5_sms_cre_i2.jsp&gubun1="+fm.key_name.value+"&gubun2="+fm.birth_dt.value+"&gubun3="+fm.destphone.value, "SEARCH_EVAL_KEY", "left=10, top=10, width=900, height=300, scrollbars=yes, status=yes, resizable=yes");	
	}		
	
//-->
</script>	
</head>

<body onLoad="javascript:document.form1.firm_nm.focus();">
<form action="" name="form1" method="post" >
<INPUT TYPE="hidden" NAME="check" value="Y">
<table width="700" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>SMS문자</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table width="700" border="0" cellspacing="1" cellpadding="0">
                <tr>
				    <td class="title" width=12%>발송대상</td>
                    <td colspan='3'>&nbsp;고객</td>
                </tr>
                <tr>
				    <td class="title" width=12%>고객</td>
                    <td  colspan='3'>&nbsp;<input type="text" name="firm_nm" size="30" class="text" value="" onKeyDown="javasript:enter()">
						<input type='hidden' name='client_id' value=''>
						<input type='hidden' name='rent_l_cd' value=''>
						<a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
						&nbsp;						
					</td>
                </tr>
                <tr>
				    <td class="title" width=12%>수신자</td>
                    <td width=38%>&nbsp;<input type="text" name="destname" size="30" class="text" value=""></td>
                    <td width=12% class="title">수신번호</td>
                    <td width=38%>&nbsp;<input type="text" name="destphone" size="15" class="text" value=""> <input type="checkbox" name="no_num" value="N">서면동의</td>
                </tr>


				 <tr>
				    <td class="title" width=12%>의뢰자</td>
                    <td width=38%>&nbsp;<select name='bus_id'>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>	
					</td>
                    <td width=12% class="title">조회등급</td>
                    <td width=38%>&nbsp;NICE : <select name='score'>
						<option value="미조회">미조회</option>
                        <option value="1등급">1등급</option>
						<option value="2등급">2등급</option>
						<option value="3등급">3등급</option>
						<option value="4등급">4등급</option>
						<option value="5등급">5등급</option>
						<option value="6등급">6등급</option>
						<option value="7등급">7등급</option>
						<option value="8등급">8등급</option>
						<option value="9등급">9등급</option>
						<option value="10등급">10등급</option>
						</select>
						&nbsp;KCB : <select name='score2'>
						<option value="미조회">미조회</option>
                        <option value="1등급">1등급</option>
						<option value="2등급">2등급</option>
						<option value="3등급">3등급</option>
						<option value="4등급">4등급</option>
						<option value="5등급">5등급</option>
						<option value="6등급">6등급</option>
						<option value="7등급">7등급</option>
						<option value="8등급">8등급</option>
						<option value="9등급">9등급</option>
						<option value="10등급">10등급</option>
						</select>
						</td>
                </tr>

                <tr>
                    <td class="title">제목 </td>
                    <td colspan="3">&nbsp;<input type='text' size='30' name='msg_subject' value='신용조회후 문자 미발송 건' maxlength='30' class='text'>&nbsp;(30자이내)</td>
                </tr>
                <tr>
                    <td class="title">메모</td>
                    <td colspan="3">&nbsp;<textarea name="msg" rows="5" cols="95" class="text">신용조회후 문자발송은 하지 않음.</textarea></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용조회 대체키</span>	        
	    </td>
	</tr>    
    <tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table width="700" border="0" cellspacing="1" cellpadding="0">	
                <tr>
				    <td class="title" width=12%>성명</td>
                    <td>&nbsp;<input type="text" name="key_name" size="15" class="text" value=""></td>                    
				    <td class="title" width=12%>생년월일</td>
                    <td >&nbsp;<input type="text" name="birth_dt" size="15" maxlength='8' class="text" value=""> (YYMMDD)</td>                    
                </tr>
                <tr>
				    <td class="title" width=12%>NICE 대체키</td>
                    <td width=38%>&nbsp;<input type="text" name="key_nice" size="15" class="text" value="">            
                    </td>
                    <td width=12% class="title">KCB 대체키</td>
                    <td width=38%>&nbsp;<input type="text" name="key_kcb" size="15" class="text" value=""> 
                    &nbsp;<a href="javascript:search_eval_key()" onMouseOver="window.status=''; return true" title="신용조회 대체키 조회하기"><img src=/acar/images/center/button_in_cf_dc.gif border=0 align=absmiddle></a>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
            
    <!--
    <tr>
        <td>
            * 개인 신용조회일때 메모에 이름/생년월일/핸드폰번호/판정기관/대체키를 넣어주세요.
        </td>
    </tr> 		
    -->
    <tr>
        <td class=h></td>
    </tr> 	
    <tr> 
        <td align="right">
			<a href="javascript:SandSms()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
			<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
		</td>
    </tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>