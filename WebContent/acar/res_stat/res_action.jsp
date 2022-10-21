<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.cont.*, acar.secondhand.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="shDb" scope="page" class="acar.secondhand.SecondhandDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "01");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);	
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());	
	String rent_st = rc_bean.getRent_st();
	//선수금정보
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");	
	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	
	//원인차량정보
	Hashtable reserv2 = rs_db.getCarInfo(rc_bean.getSub_c_id());
	
	//수금스케줄
	Vector conts = rs_db.getScdRentList(s_cd, "");
	int cont_size = conts.size();
	
	
	//월렌트2회차대여료 있으면 자동이체여부확인하여 등록하도록
	
	//자동이체를 위한 cont 빈통 만들기
	String rm_rent_mng_id = c_id;
	String rm_rent_l_cd   = "RM00000"+s_cd;
	String cms_est_dt = "";
	
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rm_rent_mng_id, rm_rent_l_cd);	
	
	int cms_scd_cnt = 0;
	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003"); 
	int bank_size = banks.length;	
				
	//주차장 정보 
  CodeBean[] goods = c_db.getCodeAll3("0027");
  int good_size = goods.length;
  
	//재리스결정차량 상담정보
	Vector sr = shDb.getShResList(c_id);
	int sr_size = sr.size();
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
		if(fm.deli_dt.value == ''){ 		alert('배차일시를 입력하십시오'); 			fm.deli_dt.focus(); 		return; }
		if(fm.deli_loc.value == ''){ 		alert('배차위치를 입력하십시오'); 			fm.deli_loc.focus(); 		return; }		
		if(fm.deli_mng_id.value == ''){ 	alert('배차담당자를 선택하십시오'); 		fm.deli_mng_id.focus(); 	return; }						
		if(fm.deli_dt.value != '')
			fm.h_deli_dt.value = fm.deli_dt.value+fm.deli_dt_h.value+fm.deli_dt_s.value;		
				
		if(fm.ret_plan_dt.value != '')
			fm.h_ret_plan_dt.value = fm.ret_plan_dt.value+fm.ret_plan_dt_h.value+fm.ret_plan_dt_s.value;
		
		
		
		if(<%=sr_size%> > 0 && !confirm('해당 차량은 재리스 고객 <%=sr_size%>명이 예약 대기중입니다. 예약담당자들에게 확인 후 배차 잡으세요')){	return;	}
			
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'res_action_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.deli_dt.focus();">

<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='f_page' value='<%=f_page%>'>
<input type='hidden' name='h_deli_dt' value=''>
<input type='hidden' name='h_ret_plan_dt' value=''>
<input type='hidden' name='car_no' value='<%=reserv.get("CAR_NO")%>'>        
<input type='hidden' name='c_firm_nm' value='<%=rc_bean2.getFirm_nm()%>'>         
<input type='hidden' name='c_client_nm' value='<%=rc_bean2.getCust_nm()%>'>      
<input type='hidden' name='cms_est_dt' value='<%=cms_est_dt%>'>      
    

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>차량관리>대차관리 <span class=style5>배차등록</span></span></td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr>                     
                    <td class=title>차량번호</td>
                    <td >&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title  width=10%>성명</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title>상호</td>
                    <td>&nbsp;<%=rc_bean2.getFirm_nm()%>
                    	<%if(rc_bean.getCust_id().equals("") && rc_bean.getRent_st().equals("6") && rc_bean.getEtc().equals("자산양수차 명의이전 등록 및 재리스 정비중")){%>
                    		자산양수차량
                    	<%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=12%>차명</td>
                    <td colspan="5">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                </tr>  
    			  <tr> 
                    <td class=title width=12%>검사유효기간</td>
                    <td width=25%>&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>" size="9" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%>" size="9" class=whitetext>
                       </td>
                    <td class=title>차령만료일</td>
                    <td width=15% >&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("CAR_END_DT")))%>" size="9" class=whitetext>
                    </td>
                    <td class=title>점검유효기간</td>
                    <td>&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_ST_DT")))%>" size="9" class=whitetext>
                      ~&nbsp; 
                      <input type="text" name="test_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_END_DT")))%>" size="9" class=whitetext>
                    </td>
                </tr>
    		</table> 
      	</td>
    </tr>
    <%if(!rc_bean.getSub_c_id().equals("")){     	
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>원인차량</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                    <td class=title width=12%>차량번호</td>
                    <td width=25%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>차명</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>  
    <%if(rc_bean.getSub_c_id().equals("") && !rc_bean.getSub_l_cd().equals("")){ 
    	//차량정보
    	reserv2 = a_db.getRentBoardSubCase(rc_bean.getSub_l_cd());
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>원인차량</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                    <td class=title width=12%>차량번호</td>
                    <td width=25%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>차명</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>  
	<%if(sr_size>0){%>
    <tr> 
        <td class=h></td>
    </tr>    	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재리스 차량예약</span></td>
    <tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
				<%	for(int i = 0 ; i < sr_size ; i++){
						Hashtable sr_ht = (Hashtable)sr.elementAt(i);
						%>
                <tr> 
                    <td class="title" width="12%">구분</td>					
                    <td align="center" width="15%"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("상담중");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("계약확정");  %>
        													
        											<%if(!String.valueOf(sr_ht.get("REG_CODE")).equals("")){
        														
        											%>
        											<br>
        											<font color='red'><b>고객 월렌트예약</b></font>
        											<%}%>
        						
        						</td>										
                    <td class="title" width="10%">예약기간</td>					
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %></td>															
                    <td class="title" width="10%">담당자</td>					
                    <td align="center" width="10%"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>															                    
                    <td class="title" width="10%">등록일시</td>					
                    <td align="center" width="15%"><%= AddUtil.ChangeDate3(String.valueOf(sr_ht.get("REG_DATE"))) %></td>
                </tr>	
                <tr>
                    <td class="title">메모</td>
                    <td colspan='7'>&nbsp;<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%></td>
                </tr>					
				<%}%>
            </table>
	    </td>
    </tr>	

	<%}%>       
    <tr> 
        <td>&nbsp;</td>
    </tr> 
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차</span></td>
    <tr>	    
    <tr><td class=line2></td></tr>       
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                	<td class=title rowspan="7" width=5%>배<br>차</td>
                <tr> 
                    <td class=title >계약구분</td>
                    <td>&nbsp;
                <%if(rent_st.equals("1")){%>
                단기대여 
                <%}else if(rent_st.equals("2")){%>
                정비대차 
                <%}else if(rent_st.equals("3")){%>
                사고대차 
                <%}else if(rent_st.equals("9")){%>
                보험대차 
                <%}else if(rent_st.equals("10")){%>
                지연대차 
                <%}else if(rent_st.equals("4")){%>
                업무대여 
                <%}else if(rent_st.equals("5")){%>
                업무지원 
                <%}else if(rent_st.equals("6")){%>
                차량정비 
                <%}else if(rent_st.equals("7")){%>
                차량점검 
                <%}else if(rent_st.equals("8")){%>
                사고수리 
                <%}else if(rent_st.equals("11")){%>
                장기대기
                
                <%}%>	
                 &nbsp; (등록일시:<%=AddUtil.ChangeDate3(rc_bean.getReg_dt())%>)
        			</td>
                </tr>
                <tr>         			                	
                    <td class=title width=15%>배차예정일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_plan_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>배차일시</td>
                    <td> 
                        &nbsp;<input type="text" name="deli_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <select name="deli_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                        </select>
                        <select name="deli_dt_s" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>배차위치</td>
                    <td>
                        &nbsp;<input type="text" name="deli_loc" value="<%=rc_bean.getDeli_loc()%>" size="60" class=text style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>배차담당자</td>
                    <td>
                    &nbsp;<select name='deli_mng_id'>
                        <option value="">미지정</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                    </select>
    			    </td>
                </tr>
                <tr>
                	<td class=title>반차예정일시</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_plan_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_plan_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                        </select>
                        <select name="ret_plan_dt_s" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                        </select>
                    </td>
            	</tr>
            </table>
        </td>
    </tr>
    
    
	<%if(rc_bean.getRent_st().equals("6") && rc_bean.getEtc().equals("자산양수차 명의이전 등록 및 재리스 정비중")){%>
    <tr>
        <td class=h></td>
    </tr>	
	<tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=17%>차량현위치</td>
                    <td> 
                      &nbsp;<SELECT NAME="park" >
						<%for(int i = 0 ; i < good_size ; i++){
                  				CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' 
                        	<%if(String.valueOf(reserv.get("PARK")).equals(good.getNm_cd())){%> selected<%}%>><%= good.getNm()%>
                        </option>
                        <%}%>                    	
        		        </SELECT>
						<input type="text" name="park_cont" value="<%=reserv.get("PARK_CONT")%>" size="35" class=text style='IME-MODE: active'>
						(기타선택시 내용)
                    </td>
                </tr>		
            </table>
        </td>
    </tr>
    <%}%>    
    
    <tr> 
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>			    
	        <a href='javascript:save();'><img src="/acar/images/center/button_conf.gif"  align="absmiddle" border="0"></a>
	    <%}%>		
	        <!--&nbsp;<a href='javascript:document.form1.reset();'><img src="/acar/images/center/button_cancel.gif" align="absmiddle" border="0"></a>-->
	        &nbsp;<a href="javascript:self.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td>&nbsp;</td>
    </tr> 
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>주차장 입출고현황</span> (등록일 10일전~반차예정일)</td>
    <tr>	    
    <tr><td class=line2></td></tr>
    <%
    	Vector p_vt = pk_db.getPark_IO_list("", "1", "4", "", String.valueOf(reserv.get("CAR_NO")), rs_db.addDay(rc_bean.getRent_dt(), -10), rc_bean.getRet_plan_dt_d());
    %>  
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>  
                <tr>               
                    <td class=title width=10%>구분</td>
                    <td class=title width=10%>담당자</td>
                    <td class=title width=15%>차량운전자</td>
                    <td class=title width=20%>주차장</td>
                    <td class=title width=10%>구분</td>
                    <td class=title width=20%>입/출고 일시</td>
                    <td class=title width=15%>등록자</td>
                </tr>     
                <%
                	if(p_vt.size() > 0 ){
            			for(int i=0; i < p_vt.size(); i++){            			
            				Hashtable p_ht = (Hashtable)p_vt.elementAt(i);
                %>           
                <tr>               
                    <td align="center">대차차량</td>
                    <td align="center">&nbsp;<%=p_ht.get("USERS_COMP")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("DRIVER_NM")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("PARK_PLACE")%></td>
                    <td align="center">&nbsp;<%if(p_ht.get("IO_GUBUN").equals("1")){%>입고<%}else if(p_ht.get("IO_GUBUN").equals("2")){%>출고<%}%></td>
                    <td align="center">&nbsp;<%=p_ht.get("REG_DT")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("PARK_MNG")%></td>
                </tr>                
                <%		}
            		}%>
            	<%	if(!String.valueOf(reserv2.get("CAR_NO")).equals("")){
            			p_vt = pk_db.getPark_IO_list("", "1", "4", "", String.valueOf(reserv2.get("CAR_NO")), rs_db.addDay(rc_bean.getRent_dt(), -10), rc_bean.getRet_plan_dt_d()); %>
            	<%
                		if(p_vt.size() > 0 ){%>
                <tr>
                    <td class=h colspan='7'></td>
                </tr>	
            	<%			for(int i=0; i < p_vt.size(); i++){            			
            					Hashtable p_ht = (Hashtable)p_vt.elementAt(i);
                %>           
                <tr>               
                    <td align="center">원인차량</td>
                    <td align="center"><%=p_ht.get("USERS_COMP")%></td>
                    <td align="center"><%=p_ht.get("DRIVER_NM")%></td>
                    <td align="center"><%=p_ht.get("PARK_PLACE")%></td>
                    <td align="center"><%if(p_ht.get("IO_GUBUN").equals("1")){%>입고<%}else if(p_ht.get("IO_GUBUN").equals("2")){%>출고<%}%></td>
                    <td align="center"><%=p_ht.get("REG_DT")%></td>
                    <td align="center"><%=p_ht.get("PARK_MNG")%></td>
                </tr>                
                <%			}
                		}
            		}%>	
            </table>
        </td>
    </tr>            
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
