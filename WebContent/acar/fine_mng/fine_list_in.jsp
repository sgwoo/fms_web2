<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	function moveTitle(){
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;                                                                            
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;      
	}
	function init(){	
		setupEvents();
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	FineBean f_r [] = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd);
%>
<table border=0 cellspacing=0 cellpadding=0 width=2000>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
            	<tr id='title' style='position:relative;z-index:1'>
            		<td width=25% class=line id='title_col0' style='position:relative;'>
            			<table border=0 cellspacing=1 width=100%>
            				<tr>
								<td width=8% class=title>연번</td>
								<td width=26% class=title>위반일자</td>
			            		<td width=17% class=title>과실여부</td>
			            		<td width=36% class=title>위반장소</td>
								<td width=13% class=title>일련번호</td>
			            	</tr>
			            </table>
			        </td>
			        <td class=line width=75%>
			        	<table  border=0 cellspacing=1 width=100%>
			        		<tr>
			        		    <td width=10% class=title>청구기관</td>
			        			<td width=17% class=title>위반내용</td>
			            		<td width=10% class=title>고지서번호</td>
			            		<td width=9% class=title>납부구분</td>
			            		<td width=10% class=title>사실확인접수일자</td>
			            		<td width=8% class=title>의견진술기한</td>
			            		<td width=8% class=title>고지서접수일</td>
			            		<td width=7% class=title>납부기한</td>
			            		<td width=7% class=title>대납일자</td>
			            		<td width=7% class=title>수금일자</td>
			            		<td width=7% class=title>납부금액</td>
			            	</tr>
		              </table>
			        </td>
				</tr>
            	<tr>
            		<td width=25% class=line id='D1_col' style='position:relative;'>
            			<table border=0 cellspacing=1 width=100%>
<%	for(int i=0; i<f_r.length; i++){
    	f_bean = f_r[i];%>
            				<tr>
								<td width=8% align="center"><%=i+1%></td>
								<td width=26% align="center"><span title="<%=f_bean.getVio_pla()%>"><a href="javascript:parent.fine_mng_sc_go('<%=f_bean.getSeq_no()%>')"><%=f_bean.getVio_dt_view()%></a></td>
			            		<td width=17% align="center"><%=f_bean.getFault_st_nm()%></td>
			            		<td width=36% align="left">&nbsp;<span title="<%=f_bean.getVio_pla()%>"><a href="javascript:parent.fine_mng_sc_go('<%=f_bean.getSeq_no()%>')"><%=Util.subData(f_bean.getVio_pla(),14)%></a></span></td>
								<td width=13% align="center"><%=f_bean.getSeq_no()%></td>								
            				</tr>
<%	}
	if(f_r.length == 0){ %>
		    		        <tr>
		            		    <td width=430 align=center height=25 colspan="5">&nbsp;</td>
			    	        </tr>
<%	}%>
			            </table>
			        </td>            		            		
            		<td class=line width=75%>
            			<table border=0 cellspacing=1 width=100%>
<%	for(int i=0; i<f_r.length; i++){
    	f_bean = f_r[i];%>
							<tr>
								<td width=10% align="center"><span title="<%=f_bean.getPol_sta()%>"><%=Util.subData(f_bean.getPol_sta(),8)%></span></td>
								<td width=17% align="center"><span title="<%=f_bean.getVio_cont()%>"><%=Util.subData(f_bean.getVio_cont(),12)%></span></td>
			            		<td width=10% align="center"><span title="<%=f_bean.getPaid_no()%>"><%=Util.subData(f_bean.getPaid_no(),16)%></td>
			            		<td width=9% align="center"><%=f_bean.getPaid_st_nm()%></td>
			            		<td width=10% align="center"><%=AddUtil.ChangeDate2(f_bean.getNotice_dt())%></td>
			            		<td width=8% align="center"><%=AddUtil.ChangeDate2(f_bean.getObj_end_dt())%></td>
			            		<td width=8% align="center"><%=f_bean.getRec_dt()%></td>
			            		<td width=7% align="center"><%=f_bean.getPaid_end_dt()%></td>
			            		<td width=7% align="center"><%=f_bean.getProxy_dt()%></td>
			            		<td width=7% align="center"><%=f_bean.getColl_dt()%></td>
			            		<td width=7% align="right"><%=Util.parseDecimal(f_bean.getPaid_amt())%> 원</td>
            				</tr>
<%	}
	if(f_r.length == 0){ %>
				            <tr>
				                <td align=left height=25 colspan="11">&nbsp;&nbsp;등록된 데이타가 없습니다.</td>
	        			    </tr>
<%	}%>
			            </table>
			        </td>            		            		
            	</tr>

            </table>
        </td>
    </tr>
</table>	
</body>
</html>