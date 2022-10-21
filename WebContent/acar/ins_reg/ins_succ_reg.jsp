<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*, acar.car_register.*"%>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String o_c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String o_ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "01");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	ins = ai_db.getIns(o_c_id, o_ins_st);
	
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(o_c_id);
	
	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;
		if(fm.o_c_id.value == '' || fm.o_ins_st.value == '' || fm.car_mng_id.value == ''){ alert('차량을 선택하십시오.'); return; }
		
		if(!confirm('승계하시겠습니까?')){	return;	}
		
		fm.target = 'i_no';
		fm.action = 'ins_succ_reg_a.jsp';
		fm.submit();
	}
	
	//검색하기
	function search(){
		var fm = document.form1;	
		window.open("about:blank", "SEARCH", "left=100, top=100, width=800, height=500, scrollbars=yes");
		var fm = document.form1;
		fm.action = "search_succ.jsp";		
		fm.target = "SEARCH";
		fm.submit();		
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function enter(idx) {
		var fm = document.form1;
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			if(idx == 1)  fm.vins_pcp_amt.focus();
			if(idx == 2)  fm.vins_gcp_amt.focus();
			if(idx == 3)  fm.vins_bacdt_amt.focus();
			if(idx == 4)  fm.vins_canoisr_amt.focus();
			if(idx == 5)  fm.vins_cacdt_cm_amt.focus();
			if(idx == 6)  fm.vins_spe.focus();
			if(idx == 7)  fm.vins_spe_amt.focus();
		}
	}
	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='ins_reg_a.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="o_c_id" value='<%=o_c_id%>'>
<input type='hidden' name="o_ins_st" value='<%=o_ins_st%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > <span class=style5>
						보험승계등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>    	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지차량</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>차량번호</td>
                    <td width=15%><%=cr_bean.getCar_no()%></td>
                    <td class=title width=10%>차명</td>
                    <td width=15%><%=cr_bean.getCar_nm()%></td>
                    <td class=title width=10%>최초등록일</td>
                    <td width=15%><%=cr_bean.getInit_reg_dt()%></td>
                    <td class=title width=10%>차대번호</td>
                    <td width=15%><%=cr_bean.getCar_num()%></td>
                </tr>		
            </table>
        </td>
    </tr>	
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>승계차량</span> &nbsp;&nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_search_s.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr><input type='hidden' name="car_mng_id" value=''> 
                    <td class=title width=10%>차량번호</td>
                    <td width=15%><input type='text' name='car_no' value='' size='15' class='whitetext'></td>
                    <td class=title width=10%>차명</td>
                    <td width=15%><input type='text' name='car_nm' value='' size='20' class='whitetext'></td>
                    <td class=title width=10%>최초등록일</td>
                    <td width=15%><input type='text' name='init_reg_dt' value='' size='12' class='whitetext'></td>
                    <td class=title width=10%>차대번호</td>
                    <td width=15%><input type='text' name='car_num' value='' size='20' class='whitetext'></td>
                </tr>		
            </table>
        </td>
    </tr>		
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험계약</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>등록구분</td>
                    <td width=15%>
                      <select name='ins_st'>
                        <option value="1">신규</option>
                        <option value="2">갱신</option>
                      </select>			
                    </td>
                    <td class=title width=10%>등록사유</td>
                    <td width=15%>
                      <select name='reg_cau'>
                        <option value=''>===신규===</option>
                        <option value='1' <%if(ins.getReg_cau().equals("1")){%>selected<%}%>>1. 신차</option>
                        <option value='2' <%if(ins.getReg_cau().equals("2")){%>selected<%}%>>2. 용도변경</option>
                        <option value='5' <%if(ins.getReg_cau().equals("5")){%>selected<%}%>>3. 오프리스</option>				
                        <option value=''>===갱신===</option>				
                        <option value='3' <%if(ins.getReg_cau().equals("3")){%>selected<%}%>>1. 담보변경</option>
                        <option value='4' <%if(ins.getReg_cau().equals("4")){%>selected<%}%>>2. 만기</option>				
                      </select>
                    </td>
                    <td class=title width=10%>담보구분</td>
                    <td width=15%>
                      <select name='ins_kd'>
                        <option value='1' <%if(ins.getIns_kd().equals("1")){%>selected<%}%>>전담보</option>
                        <option value='2' <%if(ins.getIns_kd().equals("2")){%>selected<%}%>>책임보험</option>
                      </select>
                    </td>
                    <td class=title width=10%>보험상태</td>
                    <td width=15%>
                      <select name='ins_sts'>
                        <option value='1' <%if(ins.getIns_sts().equals("1")){%>selected<%}%>>유효</option>
                        <!--<option value='2' <%if(ins.getIns_sts().equals("2")){%>selected<%}%>>만료</option>
                        <option value='3' <%if(ins.getIns_sts().equals("3")){%>selected<%}%>>중도해지</option>
                        <option value='5' <%if(ins.getIns_sts().equals("5")){%>selected<%}%>>승계</option>-->
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>보험회사</td>
                    <td> 
                      <select name='ins_com_id'>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ins.getIns_com_id().equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td class=title>계약번호</td>
                    <td> 
                      <input type='text' name='ins_con_no' size='25' value='<%=ins.getIns_con_no()%>' class='text'>
                    </td>
                    <td class=title>계약자</td>
                    <td> 
                      <input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='10' class='text'>
                    </td>
                    <td class=title>피보험자</td>
                    <td> 
                      <input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='10' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>보험기간</td>
                    <td colspan="3"> 
                      <input type="text" name="ins_start_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>" size="11" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;24시&nbsp;&nbsp;~ &nbsp;&nbsp; 
                      <input type="text" name="ins_exp_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%>" size="11" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;24시 </td>
                    <td class=title>보험종류</td>
                    <td> 
                      <select name='car_use'>
                        <option value='1' <%if(ins.getCar_use().equals("1")){%>selected<%}%>>영업용</option>
                        <option value='2' <%if(ins.getCar_use().equals("2")){%>selected<%}%>>업무용</option>
                      </select>
                    </td>
                    <td class=title>연령범위</td>
                    <td> 
                      <select name='age_scp'>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21세이상</option>
                        <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24세이상</option>
                        <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26세이상</option>
                        <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>전연령</option>
                        <option value=''>=피보험자고객=</option>				
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30세이상</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35세이상</option>				
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43세이상</option>						
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48세이상</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>에어백</td>
                    <td colspan="3"> 
                      <input type='checkbox' name='air_ds_yn' value='Y' <%if(ins.getAir_ds_yn().equals("Y")){%>checked<%}%>>
                      운전석 
                      <input type='checkbox' name='air_as_yn' value='Y' <%if(ins.getAir_as_yn().equals("Y")){%>checked<%}%>>
                      조수석</td>
                    <td class='title'>가입경력율</td>
                    <td> 
                      <input type='text' name='car_rate' size='5' maxlength='30' value='<%=ins.getCar_rate()%>' class='text'>
                      % </td>
                    <td class='title'>할인할증율</td>
                    <td> 
                      <input type='text' name='ext_rate' size='5' maxlength='30' value='<%=ins.getExt_rate()%>' class='text'>
                      % </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">담보</td>
                    <td class=title width=50%>가입금액</td>
                    <td class=title width=25%>보험료</td>
                </tr>
                <tr> 
                    <td class=title width=10%>책임보험</td>
                    <td class=title width=15%>대인배상Ⅰ</td>
                    <td>자배법 시행령에서 정한 금액</td>
                    <td align="center"> 
                      <input type='text' size='10' name='rins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(1)">
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr1 style="display:<%if(ins.getIns_kd().equals("2")) {%>none<%}else{%>''<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title rowspan="9" width=10%>임의보험</td>
                    <td class=title colspan="2">대인배상Ⅱ</td>
                    <td> 
                      <select name='vins_pcp_kd'>
                        <option value='1' <%if(ins.getVins_pcp_kd().equals("1")){%>selected<%}%>>무한</option>
                        <option value='2' <%if(ins.getVins_pcp_kd().equals("2")){%>selected<%}%>>유한</option>
                      </select>
                    </td>
                    <td align="center" > 
                      <input type='text' size='10' name='vins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(2)">
                      원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">대물배상&nbsp;&nbsp;</td>
                    <td> 
                      <select name='vins_gcp_kd'>
                        <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5억원</option>
						<option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3억원</option>
						<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2억원</option>
						<option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1억원</option>
                        <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000만원&nbsp;&nbsp;&nbsp;</option>
                        <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000만원</option>
                        <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500만원</option>
                        <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000만원</option>				
                      </select>
                      (1사고당)</td>
                    <td align="center"> 
                      <input type='text' size='10' class='num' name='vins_gcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_gcp_amt()))%>' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(3)">
                      원</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2" colspan="2">자기신체사고</td>
                    <td> 
                      <select name='vins_bacdt_kd'>
                        <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3억원</option>
                        <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1억5천만원</option>
                        <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000만원</option>
                        <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000만원</option>
                        <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500만원</option>
                        <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>미가입</option>
                      </select>
                      (1인당사망/장해)</td>
                    <td align="center" rowspan="2"> 
                      <input type='text' size='10' name='vins_bacdt_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_bacdt_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(4)">
                      원</td>
                </tr>
                <tr> 
                    <td> 
                      <select name='vins_bacdt_kc2'>
                        <option value="1" <%if(ins.getVins_bacdt_kc2().equals("1")){%>selected<%}%>>3억원</option>
                        <option value="2" <%if(ins.getVins_bacdt_kc2().equals("2")){%>selected<%}%>>1억5천만원</option>
                        <option value="6" <%if(ins.getVins_bacdt_kc2().equals("6")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kc2().equals("5")){%>selected<%}%>>5000만원</option>
                        <option value="3" <%if(ins.getVins_bacdt_kc2().equals("3")){%>selected<%}%>>3000만원</option>
                        <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")){%>selected<%}%>>1500만원</option>
                      </select>
                      (1인당부상)</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">무보험차상해</td>
                    <td> 
                      <!--
                      <select name='vins_canoisr_kd'>
                        <option value="" ></option>
                        <option value="1">3억원</option>
                        <option value="7">2억원</option>
                        <option value="2">1억5천만원</option>
                        <option value="6">1억원</option>
                        <option value="5">5000만원</option>
                        <option value="3">3000만원</option>
                        <option value="4">1500만원</option>
                      </select>
                      (피보험자 1인당 최고)-->
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='vins_canoisr_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_canoisr_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(5)">
                      원</td>
                </tr>
                <tr>
                    <td class=title rowspan="3" width=9%>자기차량손해</td>
                    <td class=title width=6%>아마존카</td>
                    <td width=50%><!--<font color="#666666">자차보험료: <%//=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>원</font>--></td>
                    <td align="center" rowspan="3" width=25%> 
                      <input type='text' size='10' name='vins_cacdt_cm_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(6)">
                      원</td>
                </tr>
                <tr>
                    <td class=title rowspan="2">보험사</td>
                    <td>차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량 
                      <input type='text' size='6' name='vins_cacdt_car_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      만원</td>
                </tr>
                <tr> 
                    <td>자기부담금 
                    <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    만원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">특약</td>
                    <td> 
                      <input type='text' size='50' name='vins_spe' value='<%=ins.getVins_spe()%>' class='text' style='IME-MODE: active' onKeyDown="javasript:enter(7)">
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='vins_spe_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_spe_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 	
        <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
        <%}%>	  
	    </td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</form>
</body>
</html>
