<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.common.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	//자동이체 등록/수정화면 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc	= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int stat = 0;
	boolean flag = true;
	
	//계약기본정보
	ContBaseBean base 	= a_db.getCont(m_id, l_cd);
	//고객정보
	ClientBean client 	= al_db.getClient(client_id);
	//차량기본정보
	ContCarBean car 	= a_db.getContCar(m_id, l_cd);
	//차량등록정보
	Hashtable car_fee 	= a_db.getCarRegFee(m_id, l_cd);
	//신차대여정보
	ContFeeBean fee 	= a_db.getContFeeNew(m_id, l_cd, "1");
	//자동이체정보
	ContCmsBean cms 	= a_db.getCmsMng(m_id, l_cd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
		
	String file_path = "";
	String theURL = "https://fms3.amazoncar.co.kr/data/";	
	String file_ext=".pdf";
	
		//대여료갯수조회(연장여부)
	int fee_size 		= af_db.getMaxRentSt(m_id, l_cd);
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
		
	//수정: 차량관리자 수정,추가
	function save(){
		var fm = document.form1;
		if(fm.cms_bank_cd.value == ''){ 		alert("신청계좌 거래은행을 입력하십시오."); 	fm.cms_bank_cd.focus(); 		return; }
		if(fm.cms_acc_no.value == ''){ 		alert("신청계좌번호를 입력하십시오."); 		fm.cms_acc_no.focus(); 		return; }
		if(fm.cms_dep_nm.value == ''){ 		alert("예금주를 입력하십시오."); 		fm.cms_dep_nm.focus(); 		return; }
		
		if(confirm('처리하시겠습니까?')){
			fm.target='i_no';
			fm.action='cms_mng_null.jsp';
			fm.submit();
		}
	}
	
	
	function go_to_list()
	{
		var fm = document.form1;
		fm.action='cms_s_frame.jsp';
		if(fm.from_page.value == '/fms2/lc_rent/cms_rm_s_frame.jsp') fm.action='/fms2/lc_rent/cms_rm_s_frame.jsp';
		fm.target='d_content';
		fm.submit();		
	}	
	
	
	
	
	//수정하기
	function doc_cms_upd(){	
		var fm = document.form1;
		
		if(fm.cms_code.value == '')		{ alert('cms 기관코드를 확인하십시오.'); return; }
		if(!confirm('CMS 기관코드 부여하시겠습니까?')){	return;	}
		fm.action = "doc_mng_cms_u_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}	
	
	//삭제
	function cms_delete(){
		var fm = document.form1;
		
		if(confirm('삭제하시겠습니까?')){
			if(confirm('삭제는 복구가 안됩니다. 진짜 삭제하시겠습니까?')){
				fm.target='i_no';
				fm.action='cms_mng_del.jsp';
				fm.submit();
			}	
		}
	}	
	
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='cms_mng_null.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='c_id' value='<%=base.getCar_mng_id()%>'>
<input type='hidden' name='seq' value='<%=cms.getSeq()%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>CMS관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr> 
    <tr> 
        <td colspan=2 align="right">        
          <a href='javascript:go_to_list()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border="0"></a>
        </td>
    </tr>    
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 	    
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=10%>계약번호</td>
                    <td width=14%>&nbsp;<%=l_cd%></td>
                    <td class='title' width=10%>상호</td>
                    <td width=18%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class='title' width=10%>계약자</td>
                    <td width=14%>&nbsp;<%=client.getClient_nm()%></td>
                    <td class='title' width=10%>차량번호</td>
                    <td width=14%>&nbsp;<%=car_fee.get("CAR_NO")%></td>
                </tr>
           
                <tr> 
                    <td class='title' width=10%>최초영업자</td>
                    <td>&nbsp;        			  
        			  <%=c_db.getNameById(base.getBus_id(),"USER")%>
        	   	 </td>		  
                    <td class='title' width=10%>통장사본</td>
                    <td>&nbsp;
                    <%
                	String content_code  = "LC_SCAN";
                	String content_seq  = m_id+""+l_cd+"19";
                
              //  	Vector attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	Vector attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, m_id, l_cd, "9", 0);
                	int attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j <1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                    %>                
                    
                                <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
        
                    <%		}
                	}
                    %>         
                    </td>
                    <td class='title' width=10%>CMS동의서</td>
                    <td>&nbsp;
                    <%
                	content_code  = "LC_SCAN";
                //	content_seq  = m_id+""+l_cd+"1"+"38";
                	content_seq  = m_id+""+l_cd+ fee_size +"38";
                
              //  	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, m_id, l_cd, "38", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
			         	for (int j = 0 ; j < 1 ; j++){
 				        	Hashtable ht = (Hashtable)attach_vt.elementAt(j);      
 				        	    
                    %>                
                    
                                <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
        
                    <%		}
                	}
                    %>         
                    </td>  
                    <td class='title' width=10%>CMS 코드</td>
                    <td>&nbsp;<input type='text' name='cms_code' size='15' class='text' >
                  <% if ( user_id.equals("000063") || user_id.equals("000212")  ||  user_id.equals("000128")     ) {%>                   
                     <a href="javascript:doc_cms_upd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
					 <% } %>                    
                     </td>                 
                </tr>                
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수납기관 및 요금 종류</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='24%' class='title'>수납기관명</td>
                    <td class='title' width=28%>담당자</td>
                    <td class='title' width=24%>대금종류</td>
                    <td class='title' width=24%>금액</td>
                </tr>
                <tr> 
                    <td align='center'> 주식회사 아마존카</td>
                    <td align="center"> 대여료청구담당자(02-392-4243)</td>
                    <td align="center"> 
                      <select name='cms_st'>
                        <option value="1" <%if(cms.getCms_st().equals("1"))%>selected<%%>>대여료</option>
                      </select>
                    </td>
                    <td align="center"> 
                        <input type='text' name='cms_amt' size='12' class='num' value="<%if(cms.getSeq().equals("")){%><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%><%}else{%><%=AddUtil.parseDecimal(cms.getCms_amt())%><%}%>" onBlur='javascript:this.value=parseDecimal(this.value);'>                원
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신청 고객(업체) 기본사항</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='24%' class='title'>구분</td>
                    <td class='title' width=28%>사업자번호</td>
                    <td class='title'>생년월일/법인등록번호</td>
                </tr>
                <tr> 
                    <td align='center'> 
                      <select name='cp_st'>
                        <option value="1" <%if(cms.getCp_st().equals("1"))%>selected<%%>>개인</option>
                        <option value="2" <%if(cms.getCp_st().equals("2") || cms.getCp_st().equals(""))%>selected<%%>>법인</option>
                      </select>
                      통장</td>
                    <td align="center">&nbsp;<%=client.getEnp_no1()%><%=client.getEnp_no2()%><%=client.getEnp_no3()%></td>
                    <td align="center">&nbsp;<%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%><%=client.getSsn2()%><%}%></td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출금이체 신청내용</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='24%' class='title'>신청구분</td>
                    <td class='title' width="28%">최초인출일자</td>
                    <td class='title' width="24%">마지막인출일자</td>
                    <td class='title' width="24%">이체일</td>
                </tr>
                <tr> 
                    <td align='center'> 
                      <select name='reg_st'>
                        <option value="1"  <%if(cms.getReg_st().equals("1"))%>selected<%%>>신청</option>
                        <option value="2"  <%if(cms.getReg_st().equals("2"))%>selected<%%>>해지</option>
                         <option value="11"  <%if(cms.getReg_st().equals("11"))%>selected<%%>>재신청</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_start_dt' size='12' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_end_dt' size='12' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      </td>
                    <td align="center"> 매월 
                      <select name='cms_day'>
        		<%for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(AddUtil.parseInt(cms.getCms_day()) == i){%> selected <%}%>><%=i%></option>
                        <%} %>
                      </select>
                      일</td>
                </tr>
                <tr> 
                    <td class='title'>신청계좌 거래은행</td>
                    <td class='title'>신청계좌번호</td>
                    <td class='title'>예금주</td>
                    <td class='title'>예금주 생년월일/사업자번호</td>
                </tr>
                <tr> 
                    <td align='center'> 
                    	<input type='hidden' name="cms_bank" 			value="<%=cms.getCms_bank()%>"> 
                      <select name='cms_bank_cd'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];	
        												//신규인경우 미사용은행 제외
    														if(bank.getUse_yn().equals("N"))	 continue;
        												if(cms.getCms_bank().equals("")){%>
                        <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}else{%>
                        <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}%>
                        <%		}
        										}
        								%>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_acc_no' size='20' class='text' value="<%=cms.getCms_acc_no()%>">
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_dep_nm' size='20' class='text' value="<%if(cms.getCms_dep_nm().equals("")){%><%=client.getFirm_nm()%><%}else{%><%=cms.getCms_dep_nm()%><%}%>" style='IME-MODE: active'>
                      </td>
                    <td align="center"> 
                      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>
                <tr> 
                    <td class='title'>예금주 주소</td>
                    <td colspan="3">&nbsp; 
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value='<%if(cms.getCms_dep_post().equals("")){%><%=client.getO_zip()%><%}else{%><%=cms.getCms_dep_post()%><%}%>'>
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="77" value='<%if(cms.getCms_dep_addr().equals("")){%><%=client.getO_addr()%><%}else{%><%=cms.getCms_dep_addr()%><%}%>'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>연락전화</td>
                    <td class='title'>휴대폰</td>
                    <td class='title' colspan="2">이메일</td>
                </tr>
                <tr> 
                    <td align='center'> 
                      <input type='text' name='cms_tel' size='15' class='text' value="<%if(cms.getCms_tel().equals("")){%><%= client.getO_tel()%><%}else{%><%=cms.getCms_tel()%><%}%>">
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_m_tel' size='15' class='text' value="<%=cms.getCms_m_tel()%>">
                    </td>
                    <td align="center" colspan="2">
                      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=cms.getCms_email()%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>계약번호/차량번호</td>
                    <td align="center">
                      <input type='text' name='cms_etc' size='20' class='text' value="<%=cms.getCms_etc()%>" >
                    </td>
                    <td class='title'>신청일자</td>
                    <td align="center">
                      <input type='text' name='app_dt' size='12' class='text' value="<%=AddUtil.ChangeDate2(cms.getApp_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color="#666666">※ 계좌번호, 예금주 생년월일/사업자번호 입력시 '-' 제외하여 입력</font></td>
        <td align="right">
        <%	if(cms.getSeq().equals("")){
        		if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border="0"></a>&nbsp;&nbsp; 
        <%		}
	    	}else{
        		if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border="0"></a>&nbsp;&nbsp;
        
        
        <%			if(cms.getCbit().equals("-") && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id))){%>
        <a href="javascript:cms_delete();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_delete.gif align=absmiddle border="0"></a>&nbsp;&nbsp;
        <%			}%>         
        <%		}
	  		}%>
        </td>
    </tr>
    <tr> 
        <td colspan='2'>&nbsp;&nbsp;<font color="#666666">※ 최초등록 : <%=cms.getReg_dt()%> <%=c_db.getNameById(cms.getReg_id(),"USER")%> / 최종수정자 : <%=cms.getUpdate_dt()%> <%=c_db.getNameById(cms.getUpdate_id(),"USER")%> / 신청자 : <%=c_db.getNameById(cms.getApp_id(),"USER")%> </font></td>
    </tr>	    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
