<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.user_mng.*, acar.cont.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");

	String s_cd 		= request.getParameter("s_cd")		==null?"":request.getParameter("s_cd");
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");		
	String f_page 		= request.getParameter("f_page")	==null?"":request.getParameter("f_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
		
	String scd_rent_st 	= request.getParameter("scd_rent_st")	==null?"":request.getParameter("scd_rent_st");
	String scd_tm 		= request.getParameter("scd_tm")	==null?"":request.getParameter("scd_tm");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	

	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	String rent_st = rc_bean.getRent_st();
	
	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	
	//스케줄정보
	ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, scd_rent_st, scd_tm);
	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003"); 
	int bank_size = banks.length;
	
	//자동이체를 위한 cont 빈통 만들기
	String rm_rent_mng_id = c_id;
	String rm_rent_l_cd   = "RM00000"+s_cd;
	
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rm_rent_mng_id, rm_rent_l_cd);
%>

<html>
<head>

<title>예약시스템 CMS신청</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
		if(fm.cms_bank.value == ''){ 	alert('CMS 은행을 선택하십시오'); 			fm.cms_bank.focus(); 			return; }
		if(fm.cms_acc_no.value == ''){ 	alert('CMS 계봐번호를 입력하십시오'); 			fm.cms_acc_no.focus(); 			return; }
		if(fm.cms_dep_nm.value == ''){ 	alert('CMS 예금주명을 입력하십시오'); 			fm.cms_dep_nm.focus(); 			return; }
		if(fm.cms_dep_ssn.value == ''){ alert('CMS 예금주 사업자/생년월일을 입력하십시오'); fm.cms_dep_ssn.focus();			return; }
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'cms_reg_a.jsp';
		fm.target = 'i_no';
		//fm.submit();			
	}		
</script>
</head>
<body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<form action="" name="form1" method="post" >
 <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' 		value='<%=user_id%>'>
 <input type='hidden' name='br_id' 		value='<%=br_id%>'>
 <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' 		value='<%=brch_id%>'> 
 <input type='hidden' name='start_dt' 		value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>   
 <input type='hidden' name='car_comp_id' 	value='<%=car_comp_id%>'>   
 <input type='hidden' name='code' 		value='<%=code%>'>     
 <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
 <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			 
 <input type='hidden' name='s_cc' 		value='<%=s_cc%>'>
 <input type='hidden' name='s_year' 		value='<%=s_year%>'> 
 <input type='hidden' name='sort_gubun' 	value='<%=sort_gubun%>'> 
 <input type='hidden' name='asc' 		value='<%=asc%>'> 
 <input type='hidden' name='from_page' 		value='<%=from_page%>'>
 <input type='hidden' name='list_from_page' 	value='<%=list_from_page%>'>
 <input type='hidden' name='s_cd' 		value='<%=s_cd%>'>
 <input type='hidden' name='c_id' 		value='<%=c_id%>'>
 <input type='hidden' name='scd_rent_st' 	value='<%=scd_rent_st%>'>
 <input type='hidden' name='scd_tm' 		value='<%=scd_tm%>'>
 
 <input type='hidden' name='car_no' 		value='<%=reserv.get("CAR_NO")%>'>        
 <input type='hidden' name='c_firm_nm' 		value='<%=rc_bean2.getFirm_nm()%>'>         
 <input type='hidden' name='c_client_nm' 	value='<%=rc_bean2.getCust_nm()%>'>       
       
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 월렌트관리 > <span class=style5>CMS신청</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>계약구분</td>
                    <td> 
                      <%if(rent_st.equals("1")){%>
                      &nbsp;단기대여 
                      <%}else if(rent_st.equals("2")){%>
                      &nbsp;정비대차 
                      <%}else if(rent_st.equals("3")){%>
                      &nbsp;사고대차 
                      <%}else if(rent_st.equals("9")){%>
                      &nbsp;보험대차 			  
                      <%}else if(rent_st.equals("10")){%>
                      &nbsp;지연대차 			  
                      <%}else if(rent_st.equals("4")){%>
                      &nbsp;업무대여 
                      <%}else if(rent_st.equals("5")){%>
                      &nbsp;업무지원 
                      <%}else if(rent_st.equals("6")){%>
                      &nbsp;차량정비 
                      <%}else if(rent_st.equals("7")){%>
                      &nbsp;차량점검 
                      <%}else if(rent_st.equals("8")){%>
                      &nbsp;사고수리 
                      <%}else if(rent_st.equals("11")){%>
                      &nbsp;기타 
                      <%}else if(rent_st.equals("12")){%>
                      &nbsp;월렌트
                      <%}%>
                    </td>
                    <td class=title width=12%>차량번호</td>
                    <td width=15%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title width=8%>성명</td>
                    <td width=10%>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title width=8%>상호</td>
                    <td width=23%>&nbsp;
                            <%=rc_bean2.getFirm_nm()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>대여기간</td>
                    <td colspan="5">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>
                     ~ <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                    <td class=title width=8%>배차</td>
                    <td width=23%>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span>&nbsp;(부가세포함)</td>
    </tr>	
    <tr><td class=line2></td></tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>    
                <tr> 
                    <td width=10% class=title>정상대여료</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt())%>원</td>                    
                    <td width=10% class=title>D/C</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt()+rf_bean.getDc_v_amt())%>원</td>                    
                    <td width=10% class=title>내비게이션</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>원</td>                    
                    <td width=10% class=title>기타</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>원</td>                    
                </tr>                            
                
            </table>
        </td>
    </tr>    
    <tr> 
        <td>&nbsp;</td>
    </tr>	    	
	<tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title rowspan="3">CMS</td>          
                    <td class=title>이체여부</td>
                    <td> 
                      &nbsp;<input type="checkbox" name="cms_reg_yn" value="Y" checked> 자동이체 등록한다.
                    </td>
                </tr>            
                <tr>                     
                    <td class=title>이체예정일</td>
                    <td> 
                      &nbsp;<input type="text" name="est_dt" value="<%=AddUtil.ChangeDate2(sr_bean.getEst_dt())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>            
                <tr> 
                    <td class=title>계좌정보</td>
                    <td> 
                      &nbsp;
                      <img src=/acar/images/center/arrow.gif> 은행:&nbsp; 
                      <select name='cms_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(rf_bean.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 계좌번호:&nbsp; 
                      <input type='text' name='cms_acc_no' value='<%=rf_bean.getCms_acc_no()%>' size='20' class='text'>
                      <br>
                      &nbsp;
                      <img src=/acar/images/center/arrow.gif> 예금주:&nbsp; 
                      <input type='text' name='cms_dep_nm' value='<%=rf_bean.getCms_dep_nm()%>' size='20' class='text'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 예금주 생년월일/사업자번호:&nbsp; 
                      <input type='text' name='cms_dep_ssn' value='<%if(rc_bean2.getCust_st().equals("개인")){%><%if(!rc_bean2.getSsn().equals("")) out.println(rc_bean2.getSsn().substring(0,6));%><%}else{%><%=rc_bean2.getEnp_no()%><%}%>' size='20' class='text'>
                      
                 <%
                	String content_code  = "SC_SCAN";
                	String content_seq  = c_id+""+s_cd+"9";
                
                	Vector attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	int attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                    
             <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
        
                <%		}
                	}else{%>         
                      <br><br>
                      &nbsp;<font color=red>(통장사본 스캔이 없습니다. 연장처리후 스캔등록하십시오.)</font>
                	
                <%	}%>	
   
                    </td>
                </tr>                              
            </table>
        </td>
    </tr> 
    <tr>
        <td>* CMS 계좌요청 및 승인으로 며칠이 소요되므로 입금예정일을 감안하여 등록하여 주십시오.</td>
    </tr>   	

        <td class=h></td>
    </tr>  		
	<tr>
	    <td align="right">
	  	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  
		 <a href='javascript:save();'><img src="/acar/images/center/button_conf.gif" border="0" align=absmiddle></a>
	  	<%}%>			
		&nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	    </td>
	</tr>
</table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
