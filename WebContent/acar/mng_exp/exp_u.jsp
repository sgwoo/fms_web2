<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*,acar.common.*"%>
<%@ page import="acar.mng_exp.*, acar.car_mst.*,acar.car_register.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}					
		popObj.location = theURL;
		popObj.focus();			
	}		

	//스캔한 등록증 보기
	function view_scanfile(path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/carReg/"+path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}		

	function modify()
	{
		if(confirm('수정하시겠습니까?'))
		{
			var fm = document.form1;
			if((fm.car_mng_id.value == '')){		alert('차량을 선택하십시오');	return;	}
			else if(!isCurrency(fm.exp_amt.value) || (parseDigit(fm.exp_amt.value).value > 9))	{	alert('금액을 확인하십시오');	return;	}
			else if(!isDate(fm.exp_est_dt.value)){	alert('지출예정일을 확인하십시오');	return;	}
			fm.target='i_no';
			fm.submit();
		}
	}
	//디스플레이 타입
	function exp_display(){
		var fm = document.form1;
		if(fm.exp_st.options[fm.exp_st.selectedIndex].value == '3'){//자동차세
			tr_dt.style.display	= '';
		}else{
			tr_dt.style.display	= 'none';
		}
	}	
	//과세기간 셋팅
	function set_exp_dt(){
		var fm = document.form1;
		var year = '<%=AddUtil.getDate(1)%>';
		var mon = <%=AddUtil.getDate(2)%>;		
		if(fm.dt_st.options[fm.dt_st.selectedIndex].value == '1'){//반기납
			if(mon <=  6){
				fm.exp_start_dt.value 	= year+'-01-01';
				fm.exp_end_dt.value 	= year+'-06-30';
			}else{
				fm.exp_start_dt.value 	= year+'-07-01';
				fm.exp_end_dt.value 	= year+'-12-31';			
			}
		}else if(fm.dt_st.options[fm.dt_st.selectedIndex].value == '2'){//연납
			fm.exp_start_dt.value 	= year+'-01-01';
			fm.exp_end_dt.value 	= year+'-12-31';			
		}else{
			fm.exp_start_dt.value 	= '';
			fm.exp_end_dt.value 	= '';
		}	
	}	


//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String exp_st = request.getParameter("exp_st")==null?"":request.getParameter("exp_st");
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
	String user_id = "";
	String br_id = "";
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "09");
	
	GenExpBean exp = ex_db.getGenExp(car_mng_id, exp_st, est_dt);
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//차량번호 이력
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	
	//매각정보
	sBean = olsD.getSui(car_mng_id);
	
  CommonDataBase c_db = CommonDataBase.getInstance();

  //차량등록지역
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	
%>
<form action='/acar/mng_exp/exp_u_a.jsp' name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='exp_st' value='<%=exp_st%>'>
<input type='hidden' name='est_dt' value='<%=est_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 영업비용관리 > 기타등록관련비용 > <span class=style1><span class=style5>지출조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td align='right'>
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){
			if(exp.getExp_st().equals("1") || exp.getExp_st().equals("2") || exp.getExp_st().equals("3")){%>
			<a href='javascript:modify()'><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;&nbsp;			
		<%}	}%>
			<a href='javascript:window.close()'><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
		</td>
	</tr> 
	<tr>
	    <td class=line2></td>
	</tr>   
    <tr>
        <td class='line'>            
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class='title'> 지출구분 </td>
                    <td colspan='3'> 
                      &nbsp;<%if(exp.getExp_st().equals("1")){%>
                      검사비 
                      <%}else if(exp.getExp_st().equals("2")){%>
                      환경개선부담금 
                      <%}else if(exp.getExp_st().equals("3")){%>
                      자동차세 
                      <%}else if(exp.getExp_st().equals("0")){%>
                      자동차등록비 
                      <%}else if(exp.getExp_st().equals("9")){%>
                      취득세 
                      <%}else if(exp.getExp_st().equals("8")){%>
                      할부비용 
                      <%}else if(exp.getExp_st().equals("7")){%>
                      설정비용 
                      <%}else if(exp.getExp_st().equals("6")){%>
                      말소비용 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width=17%>차량번호</td>
                    <td width=33%>&nbsp;<%=exp.getCar_no()%></td>
                    <td width=17% class='title'>차종</td>
                    <td width=33%>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm(), 9)%></span></td>
                </tr>
                <tr> 
                    <td class='title'> 상호 </td>
                    <td>&nbsp;<%=exp.getFirm_nm()%></td>
                    <td class='title'> 계약자 </td>
                    <td>&nbsp;<%=exp.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'> 기타사항 </td>
                    <td colspan='3'> 
                      &nbsp;<textarea name='exp_etc' cols='68' maxlength='255'><%=exp.getExp_etc()%></textarea>
                    </td>
                </tr>
                <tr id=tr_dt style="display:<%if(exp.getExp_start_dt().equals("")) {%>none<%}else{%>''<%}%>"> 
                    <td class='title'> 과세기간</td>
                    <td colspan="3">&nbsp; 
                      <input type='text' name='exp_start_dt' value="<%=AddUtil.ChangeDate2(exp.getExp_start_dt())%>" class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'>
                      ~ 
                      <input type='text' name='exp_end_dt' value="<%=AddUtil.ChangeDate2(exp.getExp_end_dt())%>" class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'>
        			  </td>
                </tr>		 
                <tr> 
                    <td class='title'>납부기관</td>
                    <td>
        			  &nbsp;<select name="car_ext">
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(exp.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select></td>
                    <td class='title'>납부차량번호</td>
                    <td>&nbsp;<input type='text' name='exp_car_no' class='text' size='15' maxlength='20'  value='<%=exp.getExp_car_no()%>'></td>			  
                </tr>		   
                <tr> 
                    <td class='title'> 금액 </td>
                    <td> 
                      &nbsp;<input type='text' name='exp_amt' class='num' size='10' maxlength='12'  value='<%=Util.parseDecimal(exp.getExp_amt())%>'onBlur='javascript:this.value = parseDecimal(this.value);'>
                      원</td>
                    <td class='title'> 지출예정일 </td>
                    <td>&nbsp;<input type='text' name='exp_est_dt' class='text' size='12' maxlength='12'  value='<%=AddUtil.ChangeDate2(exp.getExp_est_dt())%>'onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'> 지출일자</td>
                    <td colspan="3"> 
                      &nbsp;<input type='text' name='exp_dt' class='text' size='12' maxlength='12'  value='<%=AddUtil.ChangeDate2(exp.getExp_dt())%>'onBlur='javascript:this.value = ChangeDate(this.value);'>
                      &nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'> 환급사유일</td>
                    <td> 
                      &nbsp;<input type='text' name='rtn_cau_dt' class='text' size='12' maxlength='12'  value='<%=AddUtil.ChangeDate2(exp.getRtn_cau_dt())%>'onBlur='javascript:this.value = ChangeDate(this.value);'>
                      &nbsp;</td>
                    <td class='title'> 환급사유</td>
                    <td> 
                      &nbsp;<select name="rtn_cau">
                        <option value="" <%if(exp.getRtn_cau().equals(""))%> selected<%%>>선택</option>
                        <option value="1" <%if(exp.getRtn_cau().equals("1"))%> selected<%%>>용도변경</option>
                        <option value="2" <%if(exp.getRtn_cau().equals("2"))%> selected<%%>>매각</option>
                        <option value="3" <%if(exp.getRtn_cau().equals("3"))%> selected<%%>>폐차</option>
                      </select>
                      &nbsp;</td>
                </tr>		  
                <tr> 
                    <td class='title'> 환급예정금액 </td>
                    <td>
                      &nbsp;<input type='text' name='rtn_est_amt' class='num' size='10' maxlength='12'  value='<%=Util.parseDecimal(exp.getRtn_est_amt())%>'onBlur='javascript:this.value = parseDecimal(this.value);'>
                      원</td>
                    <td class='title'> 환급신청일 </td>
                    <td>&nbsp;<input type='text' name='rtn_req_dt' class='text' size='12' maxlength='12'  value='<%=AddUtil.ChangeDate2(exp.getRtn_req_dt())%>'onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'> 환급금액 </td>
                    <td> 
                      &nbsp;<input type='text' name='rtn_amt' class='num' size='10' maxlength='12'  value='<%=Util.parseDecimal(exp.getRtn_amt())%>'onBlur='javascript:this.value = parseDecimal(this.value);'>
                      원</td>
                    <td class='title'> 환급일자 </td>
                    <td>&nbsp;<input type='text' name='rtn_dt' class='text' size='12' maxlength='12'  value='<%=AddUtil.ChangeDate2(exp.getRtn_dt())%>'onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                </tr>		  
            </table>
        </td>
    </tr>
	<tr>
		<td>
              <%if(exp.getExp_st().equals("0")){%>
              * 자동차등록비 = 공채할인시 + 등록세 + 번호판제작비 + 증인지대 + 기타
              <%}else if(exp.getExp_st().equals("8")){%>
              * 할부비용 = 할부수수료 + 공증료 + 인지대
              <%}else if(exp.getExp_st().equals("7")){%>
              * 설정비용 = 설정등록세 + 설정인지대
              <%}else if(exp.getExp_st().equals("6")){%>
              * 말소비용 = 말소등록세 + 말소인지대
              <%}%>		
		</td>
	</tr>	
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량번호 이력</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>연번</td>
                    <td class=title width=15%>변경일자</td>
                    <td class=title width=15%>자동차관리번호</td>
                    <td class=title width=15%>사유</td>
                    <td class=title width=30%>상세내용</td>
                    <td class=title width=15%>등록증스캔</td>			
                </tr>
          <%if(ch_r.length > 0){
				for(int i=0; i<ch_r.length; i++){
			        ch_bean = ch_r[i];	%>
                <tr> 
                    <td align="center"><%=ch_bean.getCha_seq()%></td>
                    <td align="center"><%=ch_bean.getCha_dt()%></td>
                    <td align="center"><%=ch_bean.getCha_car_no()%></td>
                    <td align="center"> 
                      <% if(ch_bean.getCha_cau().equals("1")){%>
                      사용본거지 변경 
                      <%}else if(ch_bean.getCha_cau().equals("2")){%>
                      용도변경 
                      <%}else if(ch_bean.getCha_cau().equals("3")){%>
                      기타 
                      <%}else if(ch_bean.getCha_cau().equals("4")){%>
                      없음
                      <%}else if(ch_bean.getCha_cau().equals("5")){%>신규등록<%}%>			  
        			  </td>
                    <td bgcolor="#FFFFFF">&nbsp;<%=ch_bean.getCha_cau_sub()%></td>
                    <td align="center" >&nbsp;
                    <%if(!ch_bean.getScanfile().equals("")){%>					
					<%		if(ch_bean.getFile_type().equals("")){%>
    			    <a href="javascript:view_scanfile('<%=ch_bean.getScanfile()%>');"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%		}else{%>
    			    <a href="javascript:ScanOpen('<%= ch_bean.getScanfile() %>','<%= ch_bean.getFile_type() %>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> 					
					<%		}%>
        			<%} %>					
        			</td>			
                </tr>
          <%	}
			}else{%>
                <tr> 
                    <td colspan=5 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>	
	<%if(!sBean.getCar_mng_id().equals("")){%>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매각정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr>
                    <td width="16%" class=title>매매일자</td>
                    <td width="32%">&nbsp;<%=sBean.getCont_dt()%></td>
                    <td width="16%" class=title>명의이전일</td>
                    <td>&nbsp;<%=sBean.getMigr_dt()%></td>
                </tr>	
                <tr>
                    <td width="16%" class=title>양수인</td>
                    <td width="32%">&nbsp;<%=sBean.getSui_nm()%></td>
                    <td width="16%" class=title>매매가</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(sBean.getMm_pr())%>원</td>
                </tr>	
                <tr>
                    <td width="16%" class=title>명의이전자</td>
                    <td width="32%">&nbsp;<%=sBean.getCar_nm()%> (<%=sBean.getCar_relation()%>)</td>
                    <td width="16%" class=title>이전후번호</td>
                    <td>&nbsp;<%=sBean.getMigr_no()%></td>
                </tr>	
            </table>		
        </td>
    </tr>			
	<%}%>
	<tr>
	    <td></td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
/*	var fm = document.form1;

	//바로가기
	var s_fm = opener.parent.parent.d_search.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.car_mng_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = "";				
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
	*/
-->
</script>  
</body>
</html>