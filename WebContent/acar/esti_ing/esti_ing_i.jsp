<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	String dept_id = c_db.getUserDept(user_id);
	
	if(!dept_id.equals("0001") && !dept_id.equals("0002"))	dept_id = "";
	
	//담당자 리스트	
	Vector users = c_db.getUserList(dept_id, br_id, "EMP"); 
	int user_size = users.size();
	
	//자동차회사 리스트
	CodeBean[] companys = c_db.getCodeAll("0001"); /* 코드 구분:자동차회사 */
	int com_size = companys.length;
	
	/* 코드 구분:대여상품명 */
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); 
	int good_size = goods.length;
	//내용사이즈 기본값
	int list_size = 7;
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//목록보기
	function go_list(){
		location='esti_ing_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>';
	}
	
	//차가계산하기
	function set_amt(){
		var fm = document.form1;	
		if(fm.car_type[0].checked == true){//신차견적시에만 자동계산
//			fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));
			fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)));		
		}
	}
	
	//재리스 경우 차량번호 입력하기
	function car_no_display(idx){
		var fm = document.form1;	
		if(idx == 1){
			td_st1.style.display	= '';
			td_st2.style.display	= 'none';	
			fm.car_mng_id.value 	= '';
			fm.car_no.value 		= '';
		}else{
			td_st1.style.display	= 'none';	
			td_st2.style.display	= '';		
			//재리스이면 차량조회하기		
			var SUBWIN="./search_secondhand.jsp";	
			window.open(SUBWIN, "secondhand", "left=100, top=100, width=520, height=420, scrollbars=yes, status=yes");			
		}
	}
	
	//영업사원 조회하기
	function search_emp(){
		var fm = document.form1;		
		var SUBWIN="./search_emp.jsp?s_kd=1&t_wd="+fm.emp_nm.value;	
		window.open(SUBWIN, "emp", "left=100, top=100, width=520, height=420, scrollbars=yes, status=yes");				
	}
	
	//내용추가하기
	function line_add(){
		var fm = document.form1;	
		var size = toInt(fm.list_size.value);
		if(size < 20){
			tr_list[size].style.display	= '';	
			fm.list_size.value = size+1;			
		}else{
			alert('최대 20건까지 입력 가능합니다.');
		}
	}
	
	//견적내기
	function EstiReg(){
		var fm = document.form1;
		if(fm.est_dt.value == '')		{ alert('견적일자를 입력하십시오.'); return; }		
		if(fm.mng_id.value == '')		{ alert('담당자를 선택하십시오.'); return; }		
		if(fm.emp_nm.value == '' && fm.est_nm.value == '')		
										{ alert('거래처명을 입력하십시오'); fm.est_nm.focus(); return; }		
		if(fm.car_name.value == '')		{ alert('차종을 입력하십시오'); return; }
		if(fm.o_1.value == '' || fm.o_1.value == '0')			
										{ alert('차량가격을 입력하십시오'); return; }
		if(fm.car_type[1].checked == true && fm.car_no.value == '') //재리스
										{ alert('차량번호를 입력하십시오'); return; }
		//견적내용리스트										
		if(fm.a_a[0].value == '')		{ alert('대여상품을 선택하십시오'); return; }
		if(fm.a_b[0].value == '')		{ alert('대여기간을 입력하십시오'); return; }
		if(fm.fee_amt[0].value == '' || fm.fee_amt[0].value == '0')
										{ alert('월대여료를 입력하십시오'); return; }
										
		if(fm.emp_nm.value == '')		
			fm.emp_id.value = '';
																				
		if(!confirm('등록하시겠습니까?')){	return; }
		fm.action = 'esti_ing_i_a.jsp';
//		fm.target = "d_content";
		fm.target = "i_no";
		fm.submit();
	}	
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.emp_nm.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="./esti_ing_i_a.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
    <input type="hidden" name="gubun5" value="<%=gubun5%>">    
    <input type="hidden" name="gubun6" value="<%=gubun6%>">    	
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="list_size" value="<%=list_size%>">
    <input type="hidden" name="emp_id" value="">
    <input type="hidden" name="car_mng_id" value="">	
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 견적시스템 > <span class=style5>견적등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right" colspan="2"><a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>	  
    </tr>
    <tr>
	    <td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>견적일자</td>
                    <td width=15%> 
                      &nbsp;<input type='text' name='est_dt' value='<%=Util.getDate()%>' size='11' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>담당자</td>
                    <td width=15%>
                      &nbsp;<select name="mng_id">
                        <option value="" <%if(gubun1.equals("0"))%>selected<%%>>전체</option>
                        <%	if(user_size > 0){
        							for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        						}		%>
                      </select>
                    </td>
                    <td class=title width=10%>견적구분</td>
                    <td width=40%> 
                      &nbsp;<input type="radio" name="car_type" value="1" onclick="javascript:car_no_display(1);" checked >
                      신차 
                      <input type="radio" name="car_type" value="2" onclick="javascript:car_no_display(2);">
                      재리스</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업사원</span></td>
        <td align="right"><font color="#999999"> * 영업사원과 연결된 경우</font></td>
    </tr>
    <tr>
	    <td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>영업사원명</td>
                    <td width=40%> 
                      &nbsp;<input type="text" name="emp_nm" size="20" class=text style='IME-MODE: active'>
                      <a href="javascript:search_emp();"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
                    <td class=title width=10%>근무처</td>
                    <td width=40%> 
                      &nbsp;<input type="text" name="car_off_nm" size="40" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>전화번호</td>
                    <td> 
                      &nbsp;<input type="text" name="emp_tel" size="15" class=whitetext>
                    </td>
                    <td class=title>팩스번호</td>
                    <td> 
                      &nbsp;<input type="text" name="emp_fax" size="15" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래처</span></td>
        <td align="right"><font color="#999999"> * 거래처명은 띄어쓰기 없이 입력하십시오.</font></td>
    </tr>
    <tr>
	    <td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>거래처명</td>
                    <td width=40%> 
                      &nbsp;<input type="text" name="est_nm" size="40" class=text style='IME-MODE: active'>
                    </td>
                    <td class=title width=10%>담당자</td>
                    <td width=40%> 
                      &nbsp;<input type="text" name="est_mgr" size="30" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>전화번호</td>
                    <td> 
                      &nbsp;<input type="text" name="est_tel" size="15" class=text>
                    </td>
                    <td class=title>팩스번호</td>
                    <td> 
                      &nbsp;<input type="text" name="est_fax" size="15" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>신용구분</td>
                    <td colspan="3"> 
                      &nbsp;<input type="radio" name="spr_kd" value="3">
                      신설법인 
                      <input type="radio" name="spr_kd" value="0" checked>
                      일반고객 
                      <input type="radio" name="spr_kd" value="1">
                      우량기업 
                      <input type="radio" name="spr_kd" value="2">
                      초우량기업
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여차량</span></td>
    </tr>
    <tr>
	    <td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>제조사</td>
                    <td width=90%> 
                      &nbsp;<select name="car_comp_id">
                        <%	for ( int i = 0 ; i < com_size ; i++){
        							CodeBean company = companys[i];	%>
                        <option value='<%= company.getCode()%>'><%=company.getNm()%></option>
                        <%	}		%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>차종</td>
                    <td> 
                      &nbsp;<input type="text" name="car_name" value="" size="75" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>기본가격</td>
                    <td> 
                      &nbsp;<input type="text" name="car_amt" value="" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>옵션가격</td>
                    <td> 
                      &nbsp;<input type="text" name="opt_amt" value="" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>차량가격</td>
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td width="120"> 
                                    &nbsp;<input type="text" name="o_1" value="" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value);'>
                                    원</td>
                                <td width="600" id=td_st2 style='display:none'><font color="#999999">(중고차가)</font>&nbsp;&nbsp;차량번호 
                                    : 
                                    <input type="text" name="car_no" size="15" class=text>
                                </td>
                                <td width="600" id=td_st1 style="display:''">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적내용</span></td>
        <td align="right"><font color="#CCCCCC">(부가세포함)</font>&nbsp; 
        <a href="javascript:line_add()"><img src=/acar/images/center/button_plus.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
	    <td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width="6%">연번</td>
                    <td class=title width="21%">상품명</td>
                    <td class=title width="13%">대여기간</td>
                    <td class=title width="17%">월대여료</td>
                    <td class=title width="17%">초기납입금</td>
                    <td class=title width="13%">적용잔가율</td>
                    <td class=title width="13%">보증보험</td>
                </tr>
              <%for(int j=0; j<20; j++){%>
                <tr id=tr_list style="display:<%if(j < list_size) {%>''<%}else{%>none<%}%>"> 
                    <td align="center"><%=j+1%>
                      <input type="hidden" name="seq" value="<%=j+1%>">
                    </td>
                    <td align="center"> 
                      <select name="a_a">
                        <option value="">= &nbsp;&nbsp;선 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;택 
                        &nbsp;&nbsp;=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
        					CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>'><%= good.getNm()%></option>
                        <%}%>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="a_b" size="2" class=num>
                      개월</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="pp_amt" value="" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="ro_13" size="5" class=num>
                      %</td>
                    <td align="center"> 
                      <select name="gu_yn">
                        <option value="0" >면제</option>
                        <option value="1" selected>가입</option>
                      </select>
                    </td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr align="right"> 
        <td colspan="2"> <a href="javascript:EstiReg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a> 
        </td>
    </tr>
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe>
</body>
</html>