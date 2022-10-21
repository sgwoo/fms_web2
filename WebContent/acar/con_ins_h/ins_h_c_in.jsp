<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.con_ins_h.*"%>
<jsp:useBean id="aih_db" scope="page" class="acar.con_ins_h.AddInsurHDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	Vector ins_h_scd = aih_db.getInsurHScd_20090507(m_id, l_cd, c_id);
	int ins_scd_size = ins_h_scd.size();
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='tot_tm' value='<%=ins_scd_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='3%' class='title'>연번</td>
                    <td width='6%' class='title'>사고구분</td>
                    <td width='8%' class='title'>보험회사</td>
                    <td width='6%' class='title'>청구구분</td>					
                    <td width='9%' class='title'>청구금액</td>
                    <td width='9%' class='title'>청구일자</td>
                    <td width='8%' class='title'>입금구분</td>										
                    <td width="9%" class='title'>입금일자</td>
                    <td width='9%' class='title'>실입금액</td>
                    <td width='7%' class='title'>내고</td>
                    <td width="8%" class='title' style='height:34'>세금계산서<br>발행일자</td>
                    <td width='6%' class='title'>연체일수</td>
                    <td width='6%' class='title'>입금<br>취소</td>
                    <td width="6%" class='title'>수정<br>삭제</td>
                </tr>			
          <%	if(ins_scd_size>0){
		for(int i = 0 ; i < ins_scd_size ; i++){
			InsHScdBean ins_hs = (InsHScdBean)ins_h_scd.elementAt(i);
	   		if(ins_hs.getGubun().equals("미수금")){ //미입금%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><a href="javascript:parent.view_cont('<%=ins_hs.getAccid_id()%>', '<%=ins_hs.getAccid_st()%>')"><%=ins_hs.getAccid_st()%></a></td>
                    <td align='center'>&nbsp;<span title='<%=ins_hs.getOt_ins()%>'><%=Util.subData(String.valueOf(ins_hs.getOt_ins()), 5)%></span></td>
                    <td align='center'><%=ins_hs.getReq_gu()%></td>					
                    <td align='right'> 
                      <input type='text' name='req_amt' size='8' value='<%=Util.parseDecimal(ins_hs.getReq_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원&nbsp;</td>
                    <td align='center'><%=ins_hs.getReq_dt()%></td>
                    <td align='center'>
					  <select name="pay_gu">
                        <option value="2">대차료</option>
                        <option value="1">휴차료</option>
                      </select>
					  </td>										
                    <td align='center'> 
                      <input type='text' name='pay_dt' size='12' value='<%=ins_hs.getPay_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align='right'> 
                      <input type='text' name='pay_amt' size='8' value='<%=Util.parseDecimal(ins_hs.getPay_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원&nbsp;</td>
                    <td align='center'>-</td>
                    <td align='center'> 
                      <%=ins_hs.getExt_dt()%>
                    </td>
                    <td align='right'><%=ins_hs.getDly_days()%>일&nbsp;</td>
                    <!--<td align='right' width='60'><%//=Util.parseDecimal(ins_hs.getDly_amt())%>원</td>-->
                    <td align='center'> 
        			  <%//if(br_id.equals("S1") || br_id.equals(brch_id)){%>
                      <%	if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      <a href="javascript:parent.change_scd('p', 'N', '<%=i%>', '<%=ins_hs.getAccid_id()%>','<%=ins_hs.getSeq_no()%>')"><img src=/acar/images/center/button_in_ig.gif align=absmiddle border=0></a> 
                      <%	}else{%>
                      - 
                      <%	}%>
                      <%//}%>
                    </td>
                    <td align='center'> 
        			  <%//if(br_id.equals("S1") || br_id.equals(brch_id)){%>
                      <%	if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      <a href="javascript:parent.change_scd('u', 'N', '<%=i%>', '<%=ins_hs.getAccid_id()%>','<%=ins_hs.getSeq_no()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      <%	}else{%>
                      - 
                      <%	}%>
                      <%//}%>
                    </td>
                </tr>
          <%			}else{//입금%>
                <tr> 
                    <td class='is' align='center'><%=i+1%></td>
                    <td class='is' align='center'><a href="javascript:parent.view_cont('<%=ins_hs.getAccid_id()%>', '<%=ins_hs.getAccid_st()%>')"><%=ins_hs.getAccid_st()%></a></td>
                    <td class='is' align='center'>&nbsp;<span title='<%=ins_hs.getOt_ins()%>'><%=Util.subData(String.valueOf(ins_hs.getOt_ins()), 5)%></span></td>
                    <td align='center'><%=ins_hs.getReq_gu()%></td>										
                    <td class='is' align='right'> 
                      <input type='text' name='req_amt' size='8' value='<%=Util.parseDecimal(ins_hs.getReq_amt())%>' class='isnum'>
                      원</td>
                    <td class='is' align='center'><%=ins_hs.getReq_dt()%></td>
                    <td align='center'>
					  <select name="pay_gu">
                        <option value="2" <%if(ins_hs.getPay_gu().equals("2"))%>selected<%%>>대차료</option>
                        <option value="1" <%if(ins_hs.getPay_gu().equals("1"))%>selected<%%>>휴차료</option>
                      </select>
					</td>															
                    <td class='is' align='center'> 
                      <input type='text' name='pay_dt' size='12' value='<%=ins_hs.getPay_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='is' align='right'> 
                      <input type='text' name='pay_amt' size='8' value='<%=Util.parseDecimal(ins_hs.getPay_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td class='is' align='right'><%=Util.parseDecimal(ins_hs.getReq_amt()-ins_hs.getPay_amt())%>원</td>
                    <td class='is' align='center'><%=ins_hs.getExt_dt()%></td>
                    <td class='is' align='right'><%=ins_hs.getDly_days()%>일&nbsp;</td>
                    <!--<td class='is' align='right' width='60'><%//=Util.parseDecimal(ins_hs.getDly_amt())%>원</td>-->
                    <td class='is' align='center'> 
        			  <%//if(br_id.equals("S1") || br_id.equals(brch_id)){%>
                      <%	if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      <a href="javascript:parent.change_scd('c', 'Y', '<%=i%>', '<%=ins_hs.getAccid_id()%>','<%=ins_hs.getSeq_no()%>')"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a> 
                      <%	}else{%>
                      - 
                      <%	}%>
                      <%//}%>
                    </td>
                    <td class='is' align='center' width='7%'> 
        			  <%//if(br_id.equals("S1") || br_id.equals(brch_id)){%>
                      <%	if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      <a href="javascript:parent.change_scd('u', 'Y', '<%=i%>', '<%=ins_hs.getAccid_id()%>','<%=ins_hs.getSeq_no()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      <%	}else{%>
                      - 
                      <%	}%>
                      <%//}%>
                    </td>
                </tr>
          <%			}
		}
	}else{%>
                <tr> 
                    <td colspan='16' align='center'> 휴차료/대차료 스케줄이 없습니다 </td>
                </tr>
          <%	}%>
            </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>