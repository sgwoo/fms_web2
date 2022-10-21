<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.cls.*, acar.client.*, acar.car_mst.*, acar.car_register.*, acar.insur.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//잔가변수NEW
	EstiJgVarBean ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	String a_e = ej_bean.getJg_a();
	

	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
    <style type="text/css">
        .table-style-1 {
            font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
            color: #515150;
            font-weight: bold;
        }
        .table-back-1 {
            background-color: #B0BAEC
        }
        .table-body-1 {
            text-align: center;
            height: 26px;
        }
        .table-body-2 {
            text-align: center;
            padding-left: 10px;
            font-size: 10pt;
        }
        .font-1 {
            font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
            font-weight: bold;
        }
        .font-2 {
            font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
        }
    </style>

</head>

<body leftmargin="15">

<%-- 헤더 --%>
<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>전자확인서 > <span class=style5>발송</span></span></td>
                        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr><td class=h></td></tr>
    </table>
</div>

<%-- 확인서 출력 --%>
<div>
    <br>
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">문서</div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="100%" style="margin-top: 8px">
        <tr><td class=line2 colspan=2></td></tr>
        <tr>
            <td class="title" width=7%>연번</td>
            <td class="title" width=70%>확인서</td>
            <td class="title" width=23%>선택</td>            
        </tr>
        <tr class="table-body-1">
        	<td>1</td>
        	<td>자기차량손해확인서</td>
        	<td><!-- <button class="button" name="print1" id="print1" onclick="confirmDoc('doc','1')">보기</button>&nbsp; -->
        	    <button class="button" name="mail1" id="mail1" onclick="confirmDoc('mail','1')">발송</button></td>
        </tr>
        
        <tr class="table-body-1">
        	<td>2</td>
        	<td>
        		자동차 대여이용 계약사실 확인서 &nbsp;
        		(대여료/보증금<input type="radio" name="view_amt" value="N" checked>미표시<input type="radio" name="view_amt" value="Y">표시)
        	</td>
        	<td><!-- <button class="button" name="print2" id="print2" onclick="confirmDoc('doc','2')">보기</button>&nbsp;-->
        	    <button class="button" name="mail2" id="mail2" onclick="confirmDoc('mail','2')">발송</button></td>
        </tr>
        
        <tr class="table-body-1">
        	<td>3</td>
        	<td>자동차보험 관련 특약 약정서</td>
        	<td><!-- <button class="button" name="print3" id="print3" onclick="confirmDoc('doc','3')">보기</button>&nbsp;-->
        	    <button class="button" name="mail3" id="mail3" onclick="confirmDoc('mail','3')">발송</button></td>
        </tr>
        <tr class="table-body-1">
        	<td>4</td>
        	<td align="center">
        		자동차 장기대여 대여료의 결제수단 안내 &nbsp;
        		(<input type="radio" name="pay_way" value="ARS" checked>ARS&nbsp;&nbsp;
        		<input type="radio" name="pay_way" value="visit">방문)
        	</td>
        	<td><!-- <button class="button" name="print4" id="print4" onclick="confirmDoc('doc','4')">보기</button>&nbsp;-->
        	    <button class="button" name="mail4" id="mail4" onclick="confirmDoc('mail','4')">발송</button></td>
        </tr>  
        
        <% int idx = 4; %>
        
        <%if(AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
              
		<%	if(client.getClient_st().equals("1") && !base.getCar_mng_id().equals("")){%>
         <tr class="table-body-1">
        	<td><%=idx++ %></td>
        	<td>업무전용자동차보험 가입/미가입 신청서(법인사업자 고객용)</td>
        	<td><!-- <button class="button" name="print5" id="print5" onclick="confirmDoc('doc','5')">보기</button>&nbsp;-->
        	    <button class="button" name="mail5" id="mail5" onclick="confirmDoc('mail','5')">발송</button></td>
        </tr>
		<%	}%>
		
		<%	if(!client.getClient_st().equals("1") && !client.getClient_st().equals("2") && !base.getCar_mng_id().equals("")){%>
        <tr class="table-body-1">
        	<td><%=idx++ %></td>
        	<td>업무전용자동차보험 가입/미가입 신청서(개인사업자 고객용)</td>
        	<td><!-- <button class="button" name="print5" id="print5" onclick="confirmDoc('doc','8')">보기</button>&nbsp;-->
        	    <button class="button" name="mail5" id="mail5" onclick="confirmDoc('mail','8')">발송</button></td>
        </tr>
		<%	}%>
		
		<%}%>
		
		<%	if(!client.getClient_st().equals("1")){%>
        <tr class="table-body-1">
        	<td><%=idx++ %></td>
        	<td>CMS자동이체신청서(개인/개인사업자 고객용)</td>
        	<td>
        	    <button class="button" name="mail5" id="mail5" onclick="confirmDoc('mail','12')">발송</button></td>
        </tr>
		<%	}else{%>
		<tr class="table-body-1">
        	<td><%=idx++ %></td>
        	<td>CMS자동이체신청서(법인 고객용) - 팩스회신</td>
        	<td>
        	    <button class="button" name="mail5" id="mail5" onclick="confirmDoc('mail','13')">발송</button></td>
        </tr>		
		<%	}%>

        
        		
    </table>
</div>

<form name="printForm" method="post">
	<input type="hidden" name="est_nm" value="<%=client.getFirm_nm()%>">	
	<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">			
	<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
	<input type="hidden" name="client_id" value="<%=base.getClient_id()%>">
	<input type="hidden" name="client_st" value="<%=client.getClient_st()%>">		
	<input type="hidden" name="car_mng_id" value="<%=base.getCar_mng_id()%>">
	<input type="hidden" name="rent_st" value="<%=rent_st%>">
	<input type="hidden" name="user_id" value="<%=ck_acar_id%>">						
	<input type="hidden" name="type" value="">
	<input type="hidden" name="view_amt" value="">	
	<input type="hidden" name="pay_way" value="">
	<input type="hidden" name="view_good" value="">
	<input type="hidden" name="view_tel" value="">
	<input type="hidden" name="view_addr" value="">
	<input type="hidden" name="var1" value="<%=ck_acar_id%>">
	<input type="hidden" name="var2" value="<%=rent_l_cd%>">
	<input type="hidden" name="var3" value="<%=base.getCar_mng_id()%>">
	<input type="hidden" name="var4" value="<%=rent_mng_id%>">
	<input type="hidden" name="var5" value="<%=base.getClient_id()%>">
	<input type="hidden" name="var6" value="<%=rent_st%>">
	<input type="hidden" name="mail_yn" value="">
	<input type="hidden" name="doc_url" value="">
</form>

</body>
<script>
	
	function confirmDoc(st, type){
		
		var frmData = document.printForm;

		var url = "about:blank";
		var width = 420;
		var height = 500;
		if(st == 'doc'){
			width = 900;
			height = 800;
		}
		window.open(url, 'CONFIRM_TEMPLATE', "left=50, top=50, width="+width+", height="+height+", scrollbars=yes");
		
		var view_amt = $("input[name='view_amt']:checked").val();
		var pay_way = $("input[name='pay_way']:checked").val();
		
		frmData.type.value = type;
		frmData.view_amt.value = view_amt;
		frmData.pay_way.value = pay_way;
				
		//type = 1 ;자기차량손해확인서 
		//type = 2 ;자동차계약사실확인서
		//type = 3 ;자동차보험관련특약약정서
		//type = 4 ;결제수단안내
		//type = 5 ;임직원전용가입사실확인서(법인사업자)		
		//type = 8 ;임직원전용가입사실확인서(개인사업자)
		//type = 12 ;CMS자동이체신청서(개인/개인사업자 고객용)
		//type = 13 ;CMS자동이체신청서(법인 고객용)
		
		var doc_url = "/fms2/lc_rent/confirm_template"+type+".jsp";
		
		frmData.doc_url.value = doc_url;
		
		if(st == 'doc'){
			frmData.action = doc_url;			
		}else{
			doc_url = "/edoc_fms/acar/e_doc/confirm_template_link"+type+".jsp";
			frmData.doc_url.value = doc_url;
			frmData.action = "select_mail_input_e_doc.jsp";
		}
		
		frmData.target = "CONFIRM_TEMPLATE";
		frmData.submit();

	}	

</script>
</html>