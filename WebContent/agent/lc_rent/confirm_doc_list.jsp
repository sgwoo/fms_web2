<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.cls.*, acar.client.*, acar.car_mst.*, acar.car_register.*, acar.insur.*"%>
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
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
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
        	<td><button class="button" name="print1" id="print1" onclick="confirmDoc('doc','1')">출력</button>&nbsp;
        	    <button class="button" name="mail1" id="mail1" onclick="confirmDoc('mail','1')">발송</button></td>
        </tr>
        
        <tr class="table-body-1">
        	<td>2</td>
        	<td>
        		자동차 대여이용 계약사실 확인서 &nbsp;
        		(대여료/보증금<input type="radio" name="view_amt" value="N" checked>미표시<input type="radio" name="view_amt" value="Y">표시)
        	</td>
        	<td><button class="button" name="print2" id="print2" onclick="confirmDoc('doc','2')">출력</button>&nbsp;
        	    <button class="button" name="mail2" id="mail2" onclick="confirmDoc('mail','2')">발송</button></td>
        </tr>
        
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
		
		frmData.view_amt.value = view_amt;
				
		//type = 1 ;자기차량손해확인서 
		//type = 2 ;자동차계약사실확인서
		
		var doc_url = "/fms2/lc_rent/confirm_template"+type+".jsp";
		
		frmData.doc_url.value = doc_url;
		
		if(st == 'doc'){
			frmData.action = doc_url;		
		}else{
			frmData.action = "/fms2/lc_rent/select_mail_input_e_doc.jsp";
		}
		
		frmData.target = "CONFIRM_TEMPLATE";
		frmData.submit();

	}	

</script>
</html>