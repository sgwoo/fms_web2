<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.common.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cms.CmsDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	//String req_dt =  request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
		
	if(rent_l_cd.equals("")) return;
	
	//계약기본정보
	ContBaseBean base 	= a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client 	= al_db.getClient(base.getClient_id());
	//차량기본정보
	ContCarBean car 	= a_db.getContCar(rent_mng_id, rent_l_cd);
	//차량등록정보
	Hashtable car_fee 	= a_db.getCarRegFee(rent_mng_id, rent_l_cd);
	//신차대여정보
	ContFeeBean fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//자동이체정보
	ContCmsBean cms 	= a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
			
		//대여료갯수조회(연장여부)
	int fee_size 		= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//	출금예정일
	String est_dt = ac_db.getCmsFeeEst_dt(rent_mng_id, rent_l_cd); 
	//out.println("est_dt" + est_dt);
		
	//현재날짜와 7일(working day) 이내 신청인 경우 저장 불가 
	String afterday = ad_db.getWorkDay(AddUtil.getDate(4), 4);

	//out.println(afterday);
							
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--
				
	function save(){
		var fm = document.form1;
		
		if ( toInt('<%=est_dt%>') <  toInt('<%=afterday%>') ) { alert('기간이 촉박하여 변경요청할 수 없습니다.'); 		return;	}
				
		if(fm.cms_bank.value == '')				{ alert('거래은행을 선택하십시오'); 		fm.cms_bank.focus(); 		return;	}
		if (fm.cms_bank.value == "외환은행")		{ alert('선택할 수 없습니다. KEB하나은행은 선택하세요!!!'); fm.cms_bank.focus(); 		return;	}
		
		if(fm.cms_acc_no.value == '')				{ alert('계좌번호를 입력하십시오'); 		fm.cms_acc_no.focus(); 		return;	}
		
		if(fm.cms_dep_nm.value == '')				{ alert('예금주릉 입력하십시오'); 		fm.cms_dep_nm.focus(); 		return;	}
		if(fm.cms_dep_ssn.value == '')				{ alert('예금주 생년월일/사업자번호을 입력하십시오'); 		fm.cms_dep_ssn.focus(); 		return;	}
		
		
		if(confirm('등록하시겠습니까?')){	
			fm.action='cms_cng_reg_c_a.jsp';	
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}				
	}
	

//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}		
	
			
			
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name="fee_size"			value="<%=fee_size%>">    

<input type='hidden' name='car_mng_id' value='<%=base.getCar_mng_id()%>'>


  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약사항</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=10%>계약번호</td>
                    <td width=14%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;
                      &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='스캔관리'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
                    
                    </td>
                    <td class='title' width=10%>상호</td>
                    <td width=18%>&nbsp;<%=client.getFirm_nm()%></td>
                </tr> 
                <tr>     
                    <td class='title' width=10%>사업자번호</td>
                    <td width=14%>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                    <td class='title' width=10%>주민/법인번호</td>
                    <td width=18%>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******             
                   </td>
                </tr>             
                <tr>     
                    <td class='title' width=10%>계약자</td>
                    <td width=14%>&nbsp;<%=client.getClient_nm()%></td>
                    <td class='title' width=10%>차량번호</td>
                    <td width=14%>&nbsp;<%=car_fee.get("CAR_NO")%></td>
                </tr>                         
            </table>
        </td>
    </tr>
    <tr>
	  <td align="right">&nbsp;</td>
	</tr>
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동이체 변경전 정보</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=10%>거래은행</td>
                    <td width=14%>&nbsp;<%=Util.subData(cms.getCms_bank(),6)%></td>
                    <td class='title' width=10%>계좌번호</td>
                    <td width=18%>&nbsp;<%=cms.getCms_acc_no()%>
                     <input type='hidden' name='old_cms_bank' value='<%=cms.getCms_bank()%>' >
                      <input type='hidden' name='old_cms_acc_no' value='<%=cms.getCms_acc_no()%>' >
                    
                    </td>
                </tr>    
                                        
            </table>
        </td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>
	<tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동이체 변경내용</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                               
                <tr> 
                    <td class='title'>거래은행</td>
                    <td class='title'>계좌번호</td>
                 
                </tr>
                <tr> 
                    <td align='center'> 
                      <select name='cms_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                        <option value='<%= bank.getNm()%>' ><%=bank.getNm()%></option>
                           <%			}%>
                        <%		
        					}%>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_acc_no' size='20' class='text' >
                    </td>
                
                </tr>
    				<tr> 
                
                    <td class='title'>예금주</td>
                    <td class='title'>예금주 생년월일/사업자번호</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <input type='text' name='cms_dep_nm' size='20' class='text' value="<%if(cms.getCms_dep_nm().equals("")){%><%=client.getFirm_nm()%><%}else{%><%=cms.getCms_dep_nm()%><%}%>" style='IME-MODE: active'>
                      </td>
                    <td align="center"> 
                      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
                    </td>
                </tr>   
      	 </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>   
    <tr>
	  <td align="right">&nbsp;<a href="javascript:save();"><img src="/acar/images/center/button_save.gif"  border="0" align=absmiddle></a>&nbsp;
	  <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle>
	  </td>
	</tr>	
	  <tr>
        <td class=h></td>
    </tr>
    
    <tr>
		<td colspan="2">&nbsp;※ [대여료 입금예정일(도래)] : <font color=red>
		 <% if (  !est_dt.equals("29991231") ){ %><%=AddUtil.ChangeDate3(est_dt)%><% } %></font>
		 </td>
	</tr>	
	
    <tr> 
        <td colspan='2'>&nbsp;<font color="blue">※ 먼저 통장사본, CMS동의서를 스캔등록한후 진행하세요. 스캔등록일과 변경신청일이 같아야 처리됩니다.</font></td>
    </tr>
    	
     <tr>
        <td class=h></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
