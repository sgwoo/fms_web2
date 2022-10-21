<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*, acar.user_mng.*" %>

<%@ include file="/agent/cookies.jsp" %>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String dt = "2";
	
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
		
	UsersBean user_bean = umd.getUsersBean(ck_acar_id);
	
	Vector vt = cdb.getRentEndCondAllAgent(dt, ref_dt1, ref_dt2, gubun3, gubun4, ck_acar_id, user_bean.getSa_code() );
	int vt_size = vt.size();
	
	long total_amt 	= 0;
	long total_amt2	= 0;
	
	int count =0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
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
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}

//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="1470">
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
            	<tr id='title' style='position:relative;z-index:1'>
            		<td class=line id='title_col0' style='position:relative;' width=240>
            			<table border=0 cellspacing=1 width="100%" cellpadding=0>
            				<tr>
            					<td width=40 class=title >연번</td>
			            		<td width=100 class=title>계약번호</td>
			            		<td width=100 class=title>상호</td>
			            	</tr>
			            </table>
			        </td>
			        <td class=line width=1190>
			        	<table  border=0 cellspacing=1 cellpadding=0 width="100%">
			        		<tr>
								<td width=60 class=title>대여방식</td>
								<td width=60 class=title>대여기간</td>
								<td width=60 class=title>영업사원</td>								
			            		<td width=80 class=title>계약개시일</td>
			            		<td width=80 class=title>계약만료일</td>
			            		<td width=80 class=title>스케쥴</td>
			            		<td width=100 class=title>차명</td>
			            		<td width=80 class=title>차량번호</td>
			            		<td width=80 class=title>등록일</td>
			            		<td width=60 class=title>최초영업</td>
			            		<td width=60 class=title>영업담당</td>		
			            		<td width=60 class=title>진행</td>									
			            		<td width=70 class=title>미청구일수</td>
			            		<td width=100 class=title>미청구대여료</td>
			            		<td width=100 class=title>차량잔가</td>
			            		<td width=100 class=title>채권반영분</td>
			            	</tr>
			            </table>
			        </td>
				</tr>
<%	if(vt_size > 0){%>
            	<tr>
            		<td class=line id='D1_col' style='position:relative;' width=240>
            			<table border=0 cellspacing=1 width=100% cellpadding=0>
              <% for (int i = 0 ; i < vt_size ; i++){
					         	Hashtable ht = (Hashtable)vt.elementAt(i);%>
            				<tr>
								<td align="center" width=40>
								<a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','','1','','','')" onMouseOver="window.status=''; title='계약진행메모'; return true; " ) ><%=i+1%></a></td>
            					<td align="center" width=100><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='계약관리로 이동'><%=ht.get("RENT_L_CD")%></a></td>
            					<td align="center" width=100><span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
			            	</tr>
<%}%>
                <tr> 
                    <td class="title" colspan="3">합계</td>
                </tr>
			            </table>
			        </td>            		            		
            		<td class=line width=1190>
            			<table border=0 cellspacing=1 width=100% cellpadding=0>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){
						total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
						total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("O_1")));
					}
					%>
							<tr>
								<td width=60 align="center"><%=ht.get("RENT_WAY")%></td>
								<td width=60 align="center"><%=ht.get("CON_MON")%>개월</td>
								<td width=60 align="center"><%= Util.subData(String.valueOf(ht.get("EMP_NM")),3)%></td>								
								<td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
			            		<td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
			            		<td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
			            		<td width=100 align="center">
			            		<%if(String.valueOf(ht.get("FUEL_KD")).equals("8")){%>
			            		<font color=red>[전]</font><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),5) %></span>
			            		<%}else{%>
			            		<span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),6) %></span>
			            		<%}%>
			            		</td>
			            		<td width=80 align="center"><%=ht.get("CAR_NO")%></td>
			            		<td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
				                <td width=60 align="center"><%=ht.get("BUS_NM")%></td>
                				<td width=60 align="center"><%=ht.get("BUS_NM2")%></td>
                				<td width=60 align="center">
								<a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','','1','','','')" onMouseOver="window.status=''; title='계약진행메모'; return true; " ) >
								<%	if(String.valueOf(ht.get("RE_BUS_NM")).equals("")){%>
								<img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0>
								<%	}else{%>
								<%=ht.get("RE_BUS_NM")%>								
								<%	}%>								
								</a>
								</td>
                				<td width=70 align="right">
								<%	if(String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
								<%		if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) > 0){%>
										<%=ht.get("DLY_DAY")%>일								
								<%		}else{%>
								<%			if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >= -10){%>
										
								<%			}%>										
								<%		}%>
								<%	}%>
								</td>
                				<td width=100 align="right">
								<%	if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
								    	<%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>
								<%	}else{%>
								<%		if(String.valueOf(ht.get("CLS_REG_YN")).equals("Y")){%>
								        	해지등록
								<%		}else{%>
								<%			if(!String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
												차량반납
								<%			}%>
								<%		}%>
								<%	}%>								
								</td>
                				<td width=100 align="right"><%if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%><%=Util.parseDecimal(String.valueOf(ht.get("O_1")))%><%}%></td>
                				<td width=100 align="right"><%if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("DLY_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("O_1"))))%><%}%></td>																
			            	</tr>
<%}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		  
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>					
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>					
                    <td class="title">&nbsp;</td>		  
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		  
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt+total_amt2)%></td>
                </tr>
			            </table>
			        </td>            		            		
            	</tr>
<%}%>
<%	if(vt_size == 0){%>
	            <tr>
            		<td class=line id='D1_col' style='position:relative;' width=240>
            			<table border=0 cellspacing=1 width=100% cellpadding=0>
	           				<tr>
								<td align="center"></td>
			            	</tr>
			            </table>
			        </td>            		            		
            		<td class=line width=1190>
            			<table border=0 cellspacing=1 width=100% cellpadding=0>
							<tr>
								<td> &nbsp;등록된 데이타가 없습니다.</td>
			            	</tr>
			            </table>
			        </td>            		            		
            	</tr>
<%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>