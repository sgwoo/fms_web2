<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  	==null?acar_br:request.getParameter("br_id");
	
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String seq_no 	= request.getParameter("seq_no")	==null?"":request.getParameter("seq_no");
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String proxy_dt	= request.getParameter("proxy_dt")	==null?"":request.getParameter("proxy_dt");
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		fm = document.form1;
		if(fm.proxy_dt.value == ""){	alert("납부일자를 입력해주세요.");		fm.proxy_dt.focus();		return;		}		
		
		if(!confirm("납부일자를 등록하시겠습니까?"))	return;
		fm.action = "fine_off_pop_a.jsp";
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
  <input type='hidden' name="auth_rw" 	value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 	value="<%=user_id%>">
  <input type='hidden' name="br_id"   	value="<%=br_id%>">
  <input type="hidden" name="m_id" 		value="<%=m_id%>">
  <input type='hidden' name='c_id' 		value='<%=c_id%>'>
  <input type='hidden' name='l_cd' 		value='<%=l_cd%>'>
  <input type="hidden" name="seq_no" 	value="<%=seq_no%>">
  <input type='hidden' name="gubun"	value="<%=gubun%>">
  <input type='hidden' name="mode"	value="<%=mode%>">
<%if(gubun.equals("proxy_dt")){%>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='30%'>납부일자</td>
                    <td>
        			  &nbsp;<input type="text" name="proxy_dt" value="<%=proxy_dt%>" placeholder="예) 2019-09-09"> 			
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
        	<a href="javascript:save()">
	        <%if(proxy_dt.equals("")){ %><img src=/acar/images/center/button_reg.gif align=absmiddle border=0><%}else{%><img src="/acar/images/center/button_modify.gif" align=absmiddle border=0><%}%>	
        	</a>
        	&nbsp; <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>
</table>
<%}else if(gubun.equals("view_fine")){%>
<%	
		//과태료정보
		String res_st = "";
		String vio_dt = "";
		String vio_dt_frm = "";
		if(!c_id.equals("") && !seq_no.equals("")){//값이 있을때 검색한다.
			f_bean = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd, seq_no);
			FineGovBn = FineDocDb.getFineGov(f_bean.getPol_sta());
			//정보세팅
			if(!f_bean.getRent_st().equals("")){
				if(f_bean.getRent_st().equals("1")){			res_st = "단기대여";		}
				else if(f_bean.getRent_st().equals("2")){		res_st = "정비대차";		}
				else if(f_bean.getRent_st().equals("3")){		res_st = "사고대차";		}
				else if(f_bean.getRent_st().equals("9")){		res_st = "보험대차";		}
				else if(f_bean.getRent_st().equals("10")){	res_st = "지연대차";		}
				else if(f_bean.getRent_st().equals("4")||f_bean.getRent_st().equals("5")){		res_st = "업무대여";		}
				else if(f_bean.getRent_st().equals("6")||f_bean.getRent_st().equals("7")){		res_st = "차량정비";		}
				else if(f_bean.getRent_st().equals("8")){		res_st = "사고수리";		}
				else if(f_bean.getRent_st().equals("11")){	res_st = "예약대기";		}
				else if(f_bean.getRent_st().equals("12")){	res_st = "월렌트";		}
			}
			if(!f_bean.getVio_dt().equals("")){
				vio_dt = f_bean.getVio_dt();
				vio_dt_frm = vio_dt.substring(0,4)+"-"+vio_dt.substring(4,6)+"-"+vio_dt.substring(6,8)+" "+vio_dt.substring(8,10)+"시"+vio_dt.substring(10,12)+"분";
			}
		}
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>위반내용</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='100'>차량번호</td>
                    <td align="center" width='*'><%=f_bean.getCar_no()%>&nbsp;<%=res_st%></td>
                    <td class='title' width='100'>차종</td>
                    <td align="center" width='170'><%=f_bean.getCar_nm()%></td>
                </tr>
                <tr>
                    <td class='title'>위반일시</td>
                    <td align="center"><%=vio_dt_frm%></td>
                    <td class='title'>위반내용</td>
                    <td align="center"><%=f_bean.getVio_cont()%></td>
                </tr>
                <tr>
                    <td class='title'>위반장소</td>
                    <td align="center"><%=f_bean.getVio_pla()%></td>
                    <td class='title'>청구기관</td>
                    <td align="center"><%=FineGovBn.getGov_nm()%><br><%=FineGovBn.getTel()%></td>
                </tr>
                <tr>
                    <td class='title'>사실확인접수일</td>
                    <td align="center"><%=AddUtil.getDate3(f_bean.getNotice_dt())%></td>
                    <td class='title'>위반금액</td>
                    <td align="center"><b style="color: red;"><%=AddUtil.parseDecimal(f_bean.getPaid_amt())%></b> 원</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<%} %>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
