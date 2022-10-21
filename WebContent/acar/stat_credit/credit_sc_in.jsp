<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_credit.*"%>
<jsp:useBean id="cr_db" scope="page" class="acar.stat_credit.CreditDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rent="";
	int total_su = 0;
	long total_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//미수채권 리스트
	Vector cres = cr_db.getCreditList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int cre_size = cres.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=cre_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='485' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='485'>
                <tr>					
                    <td width='60' class='title'>연번</td>	
                    <td width='75' class='title'>채권구분</td>			
        		    <td width='100' class='title'>계약번호</td>
        		    <td width='150' class='title'>상호</td>
        		    <td width='100' class='title'>차량번호</td>
		        </tr>
            </table>
	    </td>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='32%' class='title'>차명</td>
                    <td width='12%' class='title'>해지일자</td>
                    <td width='10%' class='title'>미수구분</td>						
                    <td width='10%' class='title'>회차</td>
                    <td width='20%' class='title'>금액</td>
                    <td width='15%' class='title'>영업담당자</td>
                </tr>
            </table>
	    </td>
  </tr>
<%	if(cre_size > 0){%>
  <tr>
	    <td class='line' width='485' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='485'>
          <%		for (int i = 0 ; i < cre_size ; i++){
			Hashtable cre = (Hashtable)cres.elementAt(i);%>
                <tr> 
                    <td width='60' align='center'><a href="javascript:parent.view_memo('<%=cre.get("RENT_MNG_ID")%>','<%=cre.get("RENT_L_CD")%>','<%=cre.get("CAR_MNG_ID")%>','4','','','<%=cre.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true"><%=i+1%></a></td>
                    <td width='75' align='center'>
        			<%if(cre.get("CREDIT_ST").equals("면제")){%>			
        			<%=cre.get("CREDIT_ST")%>
        			<%}else{%>
        			<a href="javascript:parent.view_memo('<%=cre.get("RENT_MNG_ID")%>','<%=cre.get("RENT_L_CD")%>','<%=cre.get("CAR_MNG_ID")%>','9','<%=cre.get("CREDIT_ST")%>','','')" onMouseOver="window.status=''; return true"><%=cre.get("CREDIT_ST")%></a>
        			<%}%>
        			</td>						
                    <td width='100' align='center'><a href="javascript:parent.view_credit('<%=cre.get("RENT_MNG_ID")%>','<%=cre.get("RENT_L_CD")%>','<%=cre.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=cre.get("RENT_L_CD")%></a></td>
                    <td width='150' align='center'><span title='<%=cre.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=cre.get("RENT_MNG_ID")%>','<%=cre.get("RENT_L_CD")%>','1')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(cre.get("FIRM_NM")), 7)%></a></span></td>
                    <td width='100' align='center'><span title='<%=cre.get("CAR_NO")%>'><%=cre.get("CAR_NO")%></span></td>
                </tr>
          <%
				total_su = total_su + 1;
				total_amt = total_amt + Long.parseLong(String.valueOf(cre.get("AMT")));
		  		}%>		  
                <tr> 
                    <td width='60' class='title'>합계</td>
                    <td width='75' class='title'>건수</td>
                    <td width='100' class='title'><%=total_su%>건</td>
                    <td width='110' class='title'>금액</td>
                    <td width='100' class='title'><%=Util.parseDecimal(total_amt)%>원</td>
                </tr>
            </table>
	    </td>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < cre_size ; i++){
			Hashtable cre = (Hashtable)cres.elementAt(i);%>
                <tr> 
                    <td width='32%' align='center'><span title='<%=cre.get("CAR_NM")%>'><%=Util.subData(String.valueOf(cre.get("CAR_NM")), 5)%></span></td>
                    <td width='12%' align='center'><%=AddUtil.ChangeDate2((String)cre.get("CLS_DT"))%></td>
                    <td width='10%' align='center'><%=cre.get("CLS_GUBUN")%></td>			
                    <td width='10%' align='center'><%=cre.get("TM")%><%=cre.get("TM_ST")%>회 
                      <%//if(!String.valueOf(cls.get("TM")).equals("1")) out.println("(잔)");%></td>
                    <td width='20%' align='right'><%=Util.parseDecimal(String.valueOf(cre.get("AMT")))%>원&nbsp;</td>
                    <td width='15%' align='center'><%=c_db.getNameById(String.valueOf(cre.get("BUS_ID2")), "USER")%></td>
                </tr>
          <%		}%>
                <tr> 
                    <td colspan="9" class='title'>&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='485' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='485'>
                <tr>
		            <td align='center'>등록된 데이타가 없습니다</td>
		        </tr>
	        </table>
	    </td>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<% 	}%>
</table>
</form>
</body>
</html>
