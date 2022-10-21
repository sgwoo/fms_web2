<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.bank_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String fund_id 	= request.getParameter("fund_id")==null?"":request.getParameter("fund_id");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	WorkingFundBean wf = abl_db.getWorkingFundBean(fund_id);
	
	//금리이력
	Vector ints = abl_db.getWorkingFundInt(fund_id);
	int int_size = ints.size();
	
	//갱신이력
	Vector res = abl_db.getWorkingFundRe(fund_id);
	int re_size = res.size();
	
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")){ user_id = login.getCookieValue(request, "acar_id"); }
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&bank_id="+bank_id+
			"&sh_height="+sh_height+"";
	
	long f_lend_total_amt 	= wf.getCont_amt();
	long re_lend_total_amt 	= 0;
	long lend_total_amt 	= 0;
	long rest_amt = f_lend_total_amt;
	String lend_max_cont_dt = "";
	String max_int = "";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정
	function update(st, seq){
		var fm = document.form1;	
		var height = 300;
		if(st == 'wf') 				height = 400;
		else if(st == 'renew') 			height = 450;
		else if(st == 'cls')	 		height = 150;
		else if(st == 'wf_int') 		height = 250;
		else if(st == 'wf_int_add') 		height = 250;
		else if(st == 'gua') 			height = 200;
		else if(st == 'realty')			height = 200;
		window.open("working_fund_u.jsp<%=valus%>&fund_id=<%=fund_id%>&cng_item="+st+"&seq="+seq+"&max_int="+fm.max_int.value, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", resizable=yes, scrollbars=yes, status=yes");
	}



	
	//리스트
	function go_to_list()
	{
		var fm = document.form1;	
		fm.action = 'working_fund_frame.jsp';
		fm.target = 'd_content';		
		fm.submit();
	}
	
	//새로고침
	function go_to_self()
	{
		var fm = document.form1;	
		fm.action = 'working_fund_c.jsp';
		fm.target = 'd_content';		
		fm.submit();
	}

	//시설자금 조회
	function search_lend_bank(){
		var fm = document.form1;
		window.open("s_lend_bank.jsp?from_page=/fms2/bank_mng/working_fund_c.jsp&fund_id=<%=fund_id%>&cont_bn=<%=wf.getCont_bn()%>", "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//은행대출연결취소
	function cancel_lend_bank(lend_id){
		var fm = document.form1;
		if(confirm('취소하시겠습니까?'))
		{	
			fm.cng_item.value = 'lend_cancel';
			fm.lend_id.value = lend_id;
			fm.action = 'working_fund_u_a.jsp';
			fm.target = 'i_no';
			//fm.target = '_blank';
			fm.submit();
		}
	}	
//-->
</script>
</head>
<body leftmargin="15">
<form action="working_fund_u.jsp" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='bank_id' value='<%=bank_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='/fms2/bank_mng/working_fund_c.jsp'>  
  <input type='hidden' name='fund_id' 	value='<%=fund_id%>'>    
  <input type='hidden' name='cng_item' 	value=''>    
  <input type='hidden' name='lend_id' 	value=''> 
  <input type='hidden' name='max_int' value=''> 
  
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td colspan=2>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 구매자금관리 ><span class=style5>자금관리</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>            
      </td>
    </tr>
    <tr> 
      <td class=h></td>
    </tr>
    <tr>
      <td align="right"><a href="javascript:go_to_list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
    <tr> 
    <tr>
      <td class=h></td>
    </tr>	
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="6%" rowspan="2" class=title>금융기관</td>
                    <td width="7%" class=title>기관명</td>
                    <td width="20%">&nbsp;
                      <%if(wf.getCont_bn_st().equals("1")){%>제1금융권<%}%>
                      <%if(wf.getCont_bn_st().equals("2")){%>제2금융권<%}%>
                      &nbsp;
                      <%=c_db.getNameById(wf.getCont_bn(), "BANK")%>
		    </td>
                    <td width="6%" rowspan="2" class=title>담당자</td>
                    <td width="8%" class=title>직책/성명</td>
                    <td width="20%">&nbsp;
                      <%=wf.getBa_title()%>
                      /
                      <%=wf.getBa_agnt()%>
		    </td>
                    <td width="13%" class=title>관리번호</td>
                    <td width="20%">&nbsp;
                      <%=wf.getFund_no()%>
                      
                      (<%=wf.getFund_id()%>)
                      
                      </td>
                </tr>
                <tr>
                  <td class=title>거래지점</td>
                  <td>&nbsp;
                    <%=wf.getBn_br()%></td>
                  <td class=title>연락처</td>
                  <td>&nbsp;
                    <%=wf.getBn_tel()%></td>
                  <td class=title>최초등록일자</td>
                  <td>&nbsp;
                    <%=AddUtil.ChangeDate2(wf.getReg_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td colspan="2" class=title>대출구분</td>
                <td>&nbsp;
                  <%if(wf.getFund_type().equals("1")){%>운용자금
                  <%}else if(wf.getFund_type().equals("2")){%>시설자금
                  <%}%>
		</td>              
              
                <td width="6%" rowspan="4" class=title>약정일자</td>
                <td width="8%" class=title>최초일자</td>
                <td width="10%">&nbsp;
                  <%=AddUtil.ChangeDate2(wf.getCont_dt())%></td>
                <td width="6%" rowspan="2" class=title>연결계좌</td>
                <td width="7%" class=title>은행명</td>
                <td width="30%">&nbsp;
                  <%=neoe_db.getCodeByNm("bank", wf.getBank_code())%>
		</td>
              </tr>
              <tr>
                <td colspan="2" class=title>대출한도</td>
                <td>&nbsp;
                  <input type="text" class="whitenum" name="cont_amt" id="cont_amt" size="15" maxlength="15" value="<%=AddUtil.parseDecimalLong(wf.getCont_amt())%>" onBlur="javascript:this.value=parseDecimal(this.value)">원
                </td>              
                <td class=title>갱신일자</td>
                <td>&nbsp;
                  <%=AddUtil.ChangeDate2(wf.getRenew_dt())%>
                  <%if(wf.getCls_dt().equals("")){%>
                  <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
                    <a href="javascript:update('renew', '');">[갱신]</a>
                  <%}%>  
                  <%}%>
		</td>
                <td class=title>계좌번호</td>
                <td>&nbsp;
                  <%=wf.getDeposit_no()%> <%=neoe_db.getCodeByNm("depositma", wf.getDeposit_no())%>                                
		</td>
              </tr>
              <tr>
                <td width="6%" rowspan="2" class=title>대출잔액</td>
                <td width="7%" class=title>금액</td>
                <td width="20%">&nbsp;
                  <%if(wf.getFund_type().equals("1")){%>
                    <%=AddUtil.parseDecimalLong(wf.getRest_amt())%>
                  <%}else if(wf.getFund_type().equals("2")){%>
                    <input type="text" class="whitenum" name="rest_amt" id="rest_amt" size="15" maxlength="15" value="<%=AddUtil.parseDecimalLong(wf.getRest_amt())%>" onBlur="javascript:this.value=parseDecimal(this.value)">원
                  <%}%>                  
		</td>
                <td class=title>만기예정일자</td>
                <td>&nbsp;
                  <%=AddUtil.ChangeDate2(wf.getCls_est_dt())%>
		</td>
                <td colspan="2" class=title>자금인출방식</td>
                <td>&nbsp;
                  <%if(wf.getPay_st().equals("1")){%>일시출금<%}%>
		  <%if(wf.getPay_st().equals("2")){%>수시입출금<%}%>
		</td>
              </tr>
              <tr>
                <td class=title>기준일자</td>
                <td>&nbsp;
                  <%if(wf.getFund_type().equals("1")){%>
                    <%=AddUtil.ChangeDate2(wf.getRest_b_dt())%>
                  <%}else if(wf.getFund_type().equals("2")){%>
                    <input type="text" class="whitetext" name="rest_b_dt" id="rest_b_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getRest_b_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
                  <%}%>                   
		</td>
                <td class=title>해지일자</td>
                <td>&nbsp;
                  <%=AddUtil.ChangeDate2(wf.getCls_dt())%>
                  <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	                  <%if(wf.getCls_dt().equals("")){%>
	                    <a href="javascript:update('cls', '');">[해지]</a>
	                  <%}%>
                  <%}%>
		</td>
                <td colspan="2" class=title>담보제공</td>
                <td>&nbsp;
                  <input type="checkbox" name="security_st1" id="security_st1" value="Y" <%if(wf.getSecurity_st1().equals("Y")){%>checked<%}%>>
                  신용
                  <input type="checkbox" name="security_st2" id="security_st2" value="Y" <%if(wf.getSecurity_st2().equals("Y")){%>checked<%}%>>
                  보증서
                  <input type="checkbox" name="security_st3" id="security_st3" value="Y" <%if(wf.getSecurity_st3().equals("Y")){%>checked<%}%>>
                  부동산
		</td>
              </tr>
              <tr>
                <td colspan='2' class=title>회전(리볼빙)여부</td>
                <td colspan='7'>&nbsp;
                  <%if(wf.getRevolving().equals("N")){%>Non<%}%>
                  <%if(wf.getRevolving().equals("Y")){%>회전<%}%>                  
		</td>
              </tr>		                			  
              <tr>
                <td colspan="2" class=title>특이사항</td>
                <td colspan="7">&nbsp;
                  <%=wf.getNote()%>
		</td>
              </tr>
            </table>
	</td>
    </tr>
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	<td align="right"><a href="javascript:update('wf', '');"><img src="/acar/images/center/button_modify.gif"  border="0" align=absmiddle></td>
    </tr>
    <%}%>
    <%if(re_size>0){%>    			    	
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>갱신</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="3%" rowspan="2" class=title>연번</td>
                <td width="20%" rowspan="2" class=title>갱신일자</td>
                <td colspan="2" class=title>대출한도</td>
                <td colspan="2" class=title>만기예정일</td>
                <td colspan="2" class=title>대출금리</td>
              </tr>
              <tr>
                <td width="15%" class=title>변경전</td>
                <td width="15%" class=title>변경후</td>
                <td width="12%" class=title>변경전</td>
                <td width="12%" class=title>변경후</td>
                <td width="12%" class=title>변경전</td>
                <td width="11%" class=title>변경후</td>
              </tr>	    
    	      <%for(int i = 0 ; i < re_size ; i++){
			WorkingFundIntBean bean = (WorkingFundIntBean)res.elementAt(i);
			if(re_lend_total_amt == 0 && bean.getA_cont_amt()>0){
				re_lend_total_amt = bean.getA_cont_amt();
			}
	      %>		              
              <tr>
                <td align='center'><%=i+1%></td>
                <td align='center'><%=AddUtil.ChangeDate2(bean.getRenew_dt())%></td>
                <td align='right'><%=AddUtil.parseDecimalLong(bean.getA_cont_amt())%></td>                
                <td align='right'><%=AddUtil.parseDecimalLong(bean.getB_cont_amt())%></td>
                <td align='center'><%=AddUtil.ChangeDate2(bean.getA_cls_est_dt())%> </td>
                <td align='center'><%=AddUtil.ChangeDate2(bean.getB_cls_est_dt())%></td>
                <td align='center'><%=bean.getA_fund_int()%>%</td>               
                <td align='center'><%=bean.getB_fund_int()%>%</td>
              </tr>
              <%}%>    
            </table>
      </td>
    </tr>     
    <%}%>
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>금리</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <%if(int_size>0){%>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="3%" class=title>연번</td>
                <td width="8%" class=title>적용금리</td>
                <td width="18%" class=title>유효기간</td>
                <td width="8%" class=title>적용구분</td>
                <td width="10%" class=title>SPREAD</td>
                <td width="8%" class=title>기준금리</td>
                <td width="8%" class=title>기준일자</td>
                <td width="30%" class=title>특약사항</td>
                <td width="7%" class=title>-</td>
              </tr>	    
    	      <%for(int i = 0 ; i < int_size ; i++){
			WorkingFundIntBean bean = (WorkingFundIntBean)ints.elementAt(i);
			max_int = bean.getFund_int();%>		              
              <tr>
                <td align='center'><%=i+1%></td>
                <td align='center'><%=bean.getFund_int()%>%</td>
                <td align='center'><%=AddUtil.ChangeDate2(bean.getValidity_s_dt())%>~<%=AddUtil.ChangeDate2(bean.getValidity_e_dt())%></td>                
                <td align='center'>
                  <%if(bean.getInt_st().equals("1")){%>확정금리<%}%>
		  			<%if(bean.getInt_st().equals("2")){%>변동금리<%}%>                  
		</td>
                <td align='center'>
                  <%if(bean.getSpread().equals("Y")){%>유(<%=bean.getSpread_int()%>%)<%}%>
		  <%if(bean.getSpread().equals("N")){%>무<%}%> 
                </td>
                <td align='center'><%=c_db.getNameByIdCode("0023", "", bean.getApp_b_st())%></td>
                <td align='center'><%=AddUtil.ChangeDate2(bean.getApp_b_dt())%></td>                
                <td>&nbsp;<%=bean.getNote()%></td>
                <td align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><span class="b"><a href="javascript:update('wf_int', '<%=bean.getSeq()%>');"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a><%}%></span></td>
              </tr>
              <%}%>    
            </table>
      </td>
    </tr> 
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	<td align="right"><a href="javascript:update('wf_int_add', '');"><img src="/acar/images/center/button_ch.gif"  border="0" align=absmiddle></td>
    </tr>			    	             
    <%}%>
    <%}%>	
    <%if(wf.getSecurity_st2().equals("Y")){%>   
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용보증서 담보 </span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>보증서발행기관명</td>
                <td width="20%">&nbsp;
                  <%=wf.getGua_org()%></td>
                <td colspan="2" class=title>보증서유효기간</td>
                <td>&nbsp;
                  <%=AddUtil.ChangeDate2(wf.getGua_s_dt())%>
                  ~ 
                  <%=AddUtil.ChangeDate2(wf.getGua_e_dt())%>
		</td>
                <td width="13%" class=title>보증율</td>
                <td width="20%">&nbsp;
                  <%=wf.getGua_int()%>%
		</td>
              </tr>
              <tr>
                <td class=title>보증금액</td>
                <td>&nbsp;
                  <%=AddUtil.parseDecimalLong(wf.getGua_amt())%>원
		</td>
                <td width="6%" rowspan="2" class=title>담당자</td>
                <td width="8%" class=title>직책/성명</td>
                <td width="20%">&nbsp;
                  <%=wf.getGua_title()%>
                  /
                  <%=wf.getGua_agnt()%>
		</td>
                <td class=title>보증서갱신예정일</td>
                <td>&nbsp;
                  <%=AddUtil.ChangeDate2(wf.getGua_est_dt())%>
		</td>
              </tr>
              <tr>
                <td class=title>보험료</td>
                <td>&nbsp;
                  <%=AddUtil.parseDecimalLong(wf.getGua_fee())%>원
		</td>
                <td class=title>연락처</td>
                <td>&nbsp;
                  <%=wf.getGua_tel()%></td>
                <td class=title>보증서발행제출서류</td>
                <td>&nbsp;
                  <%=wf.getGua_docs()%>
		</td>
              </tr>
            </table></td>
    </tr>
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	<td align="right"><a href="javascript:update('gua', '');"><img src="/acar/images/center/button_modify.gif"  border="0" align=absmiddle></td>
    </tr>			    	    
    <%}%>
    <%}%>
    <%if(wf.getSecurity_st3().equals("Y")){%>   
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>부동산 근저당설정 담보 </span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>담보물부동산명</td>
                <td width="20%">&nbsp;
                  <%=wf.getRealty_nm()%>
		</td>
                <td width="14%" class=title>담보물주소</td>
                <td colspan="3">&nbsp;
		  <%=wf.getRealty_zip()%>
		  &nbsp;
		  <%=wf.getRealty_addr()%>
		</td>
              </tr>
              <tr>
                <td class=title>근저당설정금액</td>
                <td>&nbsp;
                  <%=AddUtil.parseDecimalLong(wf.getCltr_amt())%>원
		</td>
                <td class=title>설정일자</td>
                <td width="20%">&nbsp;
                  <%=AddUtil.ChangeDate2(wf.getCltr_dt())%></td>
                <td width="13%" class=title>지상권설정</td>
                <td width="20%">&nbsp;
                  <%if(wf.getCltr_st().equals("Y")){%>유<%}%>
		  <%if(wf.getCltr_st().equals("N")){%>무<%}%>     		  
		</td>
              </tr>
              <tr>
                <td class=title>설정권자</td>
                <td>&nbsp;
                  <%=wf.getCltr_user()%></td>
                <td class=title>설정순위</td>
                <td colspan="3">&nbsp;
                  <%=wf.getCltr_lank()%>위</td>
              </tr>
            </table>
	</td>
    </tr>
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	<td align="right"><a href="javascript:update('realty', '');"><img src="/acar/images/center/button_modify.gif"  border="0" align=absmiddle></td>
    </tr>			    	    
    <%}%>
    <%}%>
    
    <%	int lend_size = 0;
    	if(wf.getFund_type().equals("2")){    		
		Vector lends = abl_db.getWorkingFundLendBankList(wf.getFund_id());
		lend_size = lends.size();		
    %>
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대출실행현황 (은행대출연동)</span></td>
    </tr>  
    <%	if(lend_size>0){%> 
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="3%" class=title>연번</td>
                <td width="22%" class=title>계약번호</td>
                <td width="25%" class=title>계약일자</td>
                <td width="25%" class=title>약정금액</td>
                <td width="25%" class=title>대출이율</td>
              </tr>	    
    	      <%for(int i = 0 ; i < lend_size ; i++){
			Hashtable ht = (Hashtable)lends.elementAt(i);	
			lend_total_amt = lend_total_amt + AddUtil.parseDigit4(String.valueOf(ht.get("CONT_AMT")));	
						
			if(wf.getRenew_dt().equals("")){
				rest_amt = rest_amt - AddUtil.parseDigit4(String.valueOf(ht.get("CONT_AMT")));
				lend_max_cont_dt = String.valueOf(ht.get("CONT_DT"));	
			}else{
				if( AddUtil.parseInt(wf.getRenew_dt()) <= AddUtil.parseInt(String.valueOf(ht.get("CONT_DT"))) ){
					rest_amt = rest_amt - AddUtil.parseDigit4(String.valueOf(ht.get("CONT_AMT")));
					lend_max_cont_dt = String.valueOf(ht.get("CONT_DT"));	
				}
			}
			
	      %>	              
              <tr>
                <td align='center'><%=i+1%></td>
                <td align='center'><%=ht.get("LEND_ID")%></td>
                <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT")))%></td>                
                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CONT_AMT")))%>원</td>
                <td align='center'><%=ht.get("LEND_INT")%>%
                <a href="javascript:cancel_lend_bank('<%=ht.get("LEND_ID")%>')">[해제]</a>
                </td>                
              </tr>
              <%}%>   
              <tr>
                <td colspan='3' class=title>합계</td>
                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(lend_total_amt)%>원</td>
                <td class=title>&nbsp;</td>
              </tr> 
            </table>
      </td>
    </tr>     
    <%		if(wf.getCont_amt() > lend_total_amt){%>
    <tr>
        <td><a href="javascript:search_lend_bank()">[은행대출연결]</a></td>
    </tr>        
    <%		}%>
    <%	}else{%>
    <tr>
        <td class=line2></td>
    </tr>    
    <tr>
        <td>* 연결된 대출실행이 없습니다. <a href="javascript:search_lend_bank()">[은행대출연결]</a></td>
    </tr>    
    <%	}%>
    <%}%>
    
    <%
    	Vector allots = abl_db.getWorkingFundAllotCaseList(wf.getFund_id());
		int allot_size = allots.size();	
		
		if(wf.getFund_type().equals("2") && lend_size==0 && allot_size>0){
    		long h_amt1 = 0;   
    		long h_cnt1 = 0;   
    %>
    <tr> 
      <td class=h></td>
    </tr>    
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>건별대출실행현황</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="3%" class=title>연번</td>
                <td width="25%" class=title>대출일자</td>
                <td width="25%" class=title>대출건수</td>
                <td width="25%" class=title>대출금액</td>
                <td width="22%" class=title>대출이율</td>
              </tr>	    
    	      <%for(int i = 0 ; i < allot_size ; i++){
					Hashtable ht = (Hashtable)allots.elementAt(i);	
					h_amt1 = h_amt1 + AddUtil.parseDigit4(String.valueOf(ht.get("LEND_PRN")));	
					h_cnt1 = h_cnt1 + AddUtil.parseDigit4(String.valueOf(ht.get("CNT")));		
		      %>	              
              <tr>
                <td align='center'><%=i+1%></td>
                <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("LEND_DT")))%></td>
                <td align='center'><%=ht.get("CNT")%></td>                
                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("LEND_PRN")))%>원</td>
                <td align='center'><%=ht.get("LEND_INT")%>%</td>                
              </tr>
              <%}%>   
              <tr>
                <td colspan='2' class=title>합계</td>
                <td class=title ><%=AddUtil.parseDecimalLong(h_cnt1)%></td>
                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(h_amt1)%>원</td>
                <td class=title></td>
              </tr> 
            </table>
      </td>
    </tr>    
    <%} %> 
        
    
    <%
    	Vector docs = abl_db.getWorkingFundFineCardDocList(wf.getFund_id());//대출공문문서-신용할부만
		int doc_size = docs.size();
		/*
		if(doc_size==0){
			docs = abl_db.getWorkingFundFineDocList(wf.getFund_id());//대출공문문서
			doc_size = docs.size();
		}
		*/
		
    	if(wf.getFund_type().equals("2") && doc_size>0){
    		long h_amt1 = 0;
    		long h_amt2 = 0;
    		long h_cnt1 = 0;
    %> 
    <tr> 
      <td class=h></td>
    </tr>    
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대출요청공문/차량대금지급요청 카드할부 연동현황</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td rowspan='2' width="3%" class=title>연번</td>
                <td colspan='5' class=title>카드할부승인요청</td>
                <td colspan='3' class=title>차량대금지급요청</td>
              </tr>	   
              <tr>
                <td width="15%" class=title>문서번호</td>
                <td width="10%" class=title>시행일자</td>
                <td width="10%" class=title>승인일자</td>
                <td width="5%" class=title>건수</td>
                <td width="10%" class=title>금액</td>
                <td width="25%" class=title>실행일자</td>
                <td width="10%" class=title>건수</td>
                <td width="12%" class=title>금액</td>
              </tr>	    
    	      <%for(int i = 0 ; i < doc_size ; i++){
					Hashtable ht = (Hashtable)docs.elementAt(i);	
					h_amt1 = h_amt1 + AddUtil.parseDigit4(String.valueOf(ht.get("AMT4")));	
					h_amt2 = h_amt2 + AddUtil.parseDigit4(String.valueOf(ht.get("TRF_AMT")));
					
					h_cnt1 = h_cnt1 + AddUtil.parseDigit4(String.valueOf(ht.get("CNT")));
					
					
					long no_cnt = AddUtil.parseDigit4(String.valueOf(ht.get("CNT")))-AddUtil.parseDigit4(String.valueOf(ht.get("TRF_CNT")));
					long no_amt = AddUtil.parseDigit4(String.valueOf(ht.get("AMT4")))-AddUtil.parseDigit4(String.valueOf(ht.get("TRF_AMT")));
		      %>	              
              <tr>
                <td align='center'><%=i+1%></td>
                <td align='center'><%=ht.get("DOC_ID")%></td>
                <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DOC_DT")))%></td>
                <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APP_DT")))%></td>                
                <td align='center'><%=ht.get("CNT")%></td>
                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%>원</td>
                <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIN_END_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("MAX_END_DT")))%></td>
                <td align='center'><%=ht.get("TRF_CNT")%><%if(no_cnt >0){%><br>(미실행건수 <%=no_cnt%>)<%}%></td>
                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("TRF_AMT")))%>원<%if(no_amt >0){%><br>(미실행금액 <%=AddUtil.parseDecimalLong(no_amt)%>원)<%}%></td>
              </tr>
              <%}%>   
              <tr>
                <td colspan='4' class=title>합계</td>
                <td class=title><%=AddUtil.parseDecimalLong(h_cnt1)%></td>
                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(h_amt1)%>원</td>
                <td colspan='2' class=title></td>
                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(h_amt2)%>원</td>
              </tr> 
              <!-- 
              <%if((wf.getCont_amt()-h_amt1)+(wf.getCont_amt()-h_amt2) > 0){ %>
              <tr>
                <td colspan='4' class=title>잔액</td>
                <td class=title></td>
                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(wf.getCont_amt()-h_amt1)%>원</td>
                <td colspan='2' class=title></td>
                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(wf.getCont_amt()-h_amt2)%>원</td>
              </tr> 
              <%} %>
               -->
            </table>
      </td>
    </tr>    
    <%} %>    
    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	var fm = document.form1;		
	
	<%if(wf.getFund_type().equals("2") && lend_size>0){//시설자금일 경우 대출잔액 계산%>//
			
		//fm.rest_amt.value 	= parseDecimal(toInt(parseDigit(fm.cont_amt.value)) - <%=lend_total_amt%>);
		
		<%if(re_lend_total_amt>0){%>
		//fm.rest_amt.value 	= parseDecimal(<%=re_lend_total_amt%> - <%=lend_total_amt%>);
		<%}%>
		
		fm.rest_amt.value 	= parseDecimal(<%=rest_amt%>);
		
		fm.rest_b_dt.value	= '<%=AddUtil.ChangeDate2(lend_max_cont_dt)%>';
		
		if(fm.rest_b_dt.value == ''){
			fm.rest_b_dt.value	= '<%=AddUtil.ChangeDate2(wf.getRenew_dt())%>';
		}
		if(fm.rest_b_dt.value == ''){
			fm.rest_b_dt.value	= '<%=AddUtil.ChangeDate2(wf.getCont_dt())%>';
		}
		
	<%}%>
	
	fm.max_int.value = '<%=max_int%>';
//-->
</script>
</body>
</html>