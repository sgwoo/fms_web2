<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.ext.*, acar.fee.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.res_search.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
		
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	

	//2. 자동차--------------------------
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	
	

	//3. 대여-----------------------------
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//월렌트정보
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
		
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	

	
	from_page = "/fms2/lc_rent/lc_c_c_rm.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
	}
	
	//카드결제연동번호발송
	function ax_hub_orderno_send(rent_st, rent_seq, fee_tm){
		var fm = document.form1;
		fm.scd_rent_st.value 	= rent_st;
		fm.scd_rent_seq.value 	= rent_seq;
		fm.scd_fee_tm.value 	= fee_tm;
		window.open("about:blank", "AX_HUB_ORDER_SEND", "left=100, top=10, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");			
		fm.target = 'AX_HUB_ORDER_SEND';
		fm.action = 'ax_hub_order_send.jsp';
		fm.submit();			
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
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">            
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">            
  <input type='hidden' name="client_id"			value="<%=base.getClient_id()%>">            
 <input type='hidden' name='scd_rent_st' value=''>   
 <input type='hidden' name='scd_rent_seq' value=''>   
 <input type='hidden' name='scd_fee_tm' value=''>   
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>

    <!-- 첫회차 카드결제 요청 -->
    <%
    	//대여료스케줄 한회차 정보
	FeeScdBean fee_scd = af_db.getScdNew(rent_mng_id, rent_l_cd, "1", "1", "1", "0");
	
	//결제연동 기발행건이 있는지 확인한다.
	Hashtable ht_ax = rs_db.getAxHubCase(rent_mng_id, rent_l_cd, fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt());
	String am_ax_code = String.valueOf(ht_ax.get("AM_AX_CODE"))==null?"":String.valueOf(ht_ax.get("AM_AX_CODE"));
	
	//신용카드결제
	Vector cards = rs_db.getRentContCardList(rent_mng_id, rent_l_cd);
	int card_size = cards.size();

    %>


    
    <%	if(!fee_scd.getRent_mng_id().equals("") && fee_scd.getRc_dt().equals("")){%>
    
    <tr> 
        <td colspan="2"><a name="scan"><img src=/acar/images/center/icon_arrow.gif align=absmiddle></a> <span class=style2>첫회차 온라인카드결제 요청
		</td>
    </tr>    
	<tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>월대여료</td>
                    <td width='37%' >&nbsp;
        		    <%=AddUtil.parseDecimal(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt())%>원 (공급가 
                    <%=AddUtil.parseDecimal(fee_scd.getFee_s_amt())%>
                    원 / 부가세 <%=AddUtil.parseDecimal(fee_scd.getFee_v_amt())%>
                    원, 
                    &nbsp;                    
                	)                	                        
                	<!--<a href="javascript:ax_hub_orderno_send('<%=fee_scd.getRent_st()%>','<%=fee_scd.getRent_seq()%>','<%=fee_scd.getFee_tm()%>');"><img src="/acar/images/center/button_in_nsend.gif" align="absmiddle" border="0" title="결제인증번호발송"></a>-->                	
                    </td>
                    <td width='10%' class='title'>사용기간</td>
                    <td width='15%'>&nbsp;
        		    <%=AddUtil.ChangeDate2(fee_scd.getUse_s_dt())%>
                    ~ 
                    <%=AddUtil.ChangeDate2(fee_scd.getUse_e_dt())%>
					</td>
                    <td width='10%' class='title'>입금예정일</td>
                    <td width='15%'>&nbsp;
    		        <%=AddUtil.ChangeDate2(fee_scd.getFee_est_dt())%>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>           
    <tr>
	    <td>&nbsp;</td>
	</tr>    
    <%	}%>
    
    <%	if(card_size > 0){%>
    <tr>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>온라인 신용카드결제</span></td>
    </tr>    
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                 <tr>
                  <td width="10%" class=title>연번</td>
                  <td width="15%" class=title>인증번호</td>
                  <td width="15%" class=title>휴대폰번호</td>		  
                  <td width="10%" class=title>금액</td>
                  <td width="10%" class=title>카드종류</td>
                  <td width="15%" class=title>회원성명</td>
                  <td width="15%" class=title>관계</td>
                  <td width="10%" class=title>상태</td>		  
                </tr>    
    <%		for(int i = 0 ; i < card_size ; i++){
    			Hashtable card = (Hashtable)cards.elementAt(i);%>	
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=card.get("AM_AX_CODE")%></td>
                  <td align="center"><%=card.get("AM_M_TEL")%></td>		  
                  <td align="right"><%=Util.parseDecimal(String.valueOf(card.get("AM_GOOD_AMT")))%>원</td>
                  <td align="center"><%=card.get("CARD_NAME")%></td>
                  <td align="center"><%=card.get("AM_CARD_SIGN")%></td>		  
                  <td align="center"><%=card.get("AM_CARD_REL")%></td>		  
                  <td align="center"><%if(String.valueOf(card.get("TNO")).equals("")){%>대기<%}else{%>결재<%}%></td>		  
                </tr>      			
    <%		}%>
                                
            </table>
        </td>
    </tr>        
    <tr>
	    <td>&nbsp;</td>
	</tr>    
    <%	}%>              
    
           
    

    

    

    
    

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	//바로가기
	var s_fm = parent.parent.top_menu.document.form1;
	var fm 		= document.form1;	
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";
	

	
//-->
</script>
</body>
</html>
