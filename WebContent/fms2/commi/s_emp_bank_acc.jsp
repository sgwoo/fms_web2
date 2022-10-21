<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*"%>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String emp_id 		= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//영업사원정보
	coe_bean = cod.getCarOffEmpBean(emp_id);
	
	//영업소정보
	co_bean = cod.getCarOffBean(coe_bean.getCar_off_id()); 
	
	//기타계좌리스트
	Vector vt = c_db.getBankAccList("emp_id", emp_id, "");
	int vt_size = vt.size();
	
	String content_code = "BANK_ACC";
	String content_seq  = "emp_id";
	
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function setCarOffBank(seq, acc_nm, acc_ssn, etc, bank, acc_no, acc_zip, acc_addr, file_name1, file_name2, file_gubun1, file_gubun2, cust_st, bank_cd){
		opener.form1.emp_acc_nm.value 		= acc_nm;
		opener.form1.rel.value 			= etc;
		if(cust_st=='2')		opener.form1.rec_incom_yn.value 	= '2';	
		else				opener.form1.rec_incom_yn.value 	= '1';	
		opener.form1.rec_incom_st.value 	= cust_st;
		opener.form1.emp_bank.value 		= bank;
		opener.form1.emp_bank_cd.value 		= bank_cd;
		opener.form1.emp_acc_no.value 		= acc_no;	
		opener.form1.rec_ssn.value 		= acc_ssn;	
		opener.form1.t_zip.value 		= acc_zip;
		opener.form1.t_addr.value 		= acc_addr;
		opener.form1.s_file_name1.value 	= file_name1;	
		opener.form1.s_file_name2.value 	= file_name2;	
		opener.form1.s_file_gubun1.value 	= file_gubun1;	
		opener.form1.s_file_gubun2.value 	= file_gubun2;			
		opener.set_amt();
		self.close();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,fileExtension,winName,features) { //v2.0
		if(fileExtension == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
			window.open(theURL,winName,features);

		}else{
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+""+fileExtension;
			window.open(theURL,winName,features);
			//window.open('/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL,'popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}		
	}
	
	//영업소계좌관리
	function BankAccMng(){
		var SUBWIN="/acar/car_office/car_offemp_bank.jsp?emp_id=<%=emp_id%>";	
		window.open(SUBWIN, "OfficeBank", "left=100, top=100, width=920, height=500, scrollbars=yes");
	}		
//-->
</script>
</head>

<body>
<form name='form1' method='post' action=''>
<table border=0 cellspacing=0 cellpadding=0 width="900">
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 영업사원관리 > <span class=style5>실수령인관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=15% class=title>근무처</td>
			    	<td width=35%><%= co_bean.getCar_off_nm() %></td>
			    	<td width=15% class=title>성명</td>
			        <td width=35%><%= coe_bean.getEmp_nm() %></td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>			
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업사원</span></td>
    </tr>				
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=40 class=title>연번</td>								
			    	<td width=80 class=title>성명</td>					
			    	<td width=120 class=title>생년월일</td>										
			    	<td width=80 class=title>관계</td>										
			    	<td width=100 class=title>은행</td>				
			    	<td width=160 class=title>계좌번호</td>
			    	<td width=200 class=title>주소</td>					
			    	<td width=60 class=title>신분증</td>					
			    	<td width=60 class=title>통장</td>					
            	</tr>
<%
					//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
					content_code = "CAR_OFF_EMP";
					content_seq  = emp_id;

					attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
					attach_vt_size = attach_vt.size();	
    					
%>            	
            	<tr>
			    	<td align=center>-</td>				
			    	<td align=center><a href="javascript:setCarOffBank('0','<%= coe_bean.getEmp_nm() %>','<%= coe_bean.getEmp_ssn1() %>-<%= coe_bean.getEmp_ssn2() %>','본인','<%=coe_bean.getEmp_bank()%>','<%=coe_bean.getEmp_acc_no()%>','<%= coe_bean.getEmp_post() %>','<%= coe_bean.getEmp_addr() %>','<%=coe_bean.getFile_name1()%>','<%=coe_bean.getFile_name2()%>','<%= coe_bean.getFile_gubun1() %>','<%= coe_bean.getFile_gubun2() %>','<%=coe_bean.getCust_st()%>','<%=coe_bean.getBank_cd()%>')" onMouseOver="window.status=''; return true"><%= coe_bean.getEmp_nm() %></a></td>
			    	<td align=center><%= coe_bean.getEmp_ssn1() %></td>
			    	<td align=center>본인</td>
			    	<td align=center><%=coe_bean.getEmp_bank()%></td>
			        <td align=center><%=coe_bean.getEmp_acc_no()%></td>
				<td align=center><%= coe_bean.getEmp_addr() %></td>										
			        <td align=center>
			                        <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"1")){    									
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}%>			        			        
			        </td>
				<td align=center>
			                        <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"2")){    									
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}%>			        			        				
				</td>
            	</tr>
            </table>
        </td>
    </tr>		
    <tr> 
        <td>※ 실수령인 유의사항 : 영업담당자가 개인 사정으로 영업 수당을 직접 받기가 어려운 경우에 실수령인을 지정할 수 있습니다. 이때 실수령인은 영업담당자와 가족관계이거나 친인척이어야만 합니다(사전협의, 증빙첨부 필수).
따라서 영업담당자의 직장동료 등 타인은 실수령인으로 등록할 수가 없습니다.</td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>실수령인</span></td>
    </tr>				
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=40 class=title>연번</td>								
			    	<td width=80 class=title>성명</td>					
			    	<td width=120 class=title>생년월일</td>										
			    	<td width=80 class=title>관계</td>										
			    	<td width=100 class=title>은행</td>				
			    	<td width=160 class=title>계좌번호</td>
			    	<td width=200 class=title>주소</td>	
			    	<td width=60 class=title>신분증</td>					
			    	<td width=60 class=title>통장</td>				
            	</tr>
				<%	for (int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);
    					
					//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
					content_code = "BANK_ACC";
					content_seq  = "emp_id"+emp_id+""+String.valueOf(ht.get("SEQ"));

					attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
					attach_vt_size = attach_vt.size();	
    					%>
            	<tr>
			    	<td align=center><%=i+1%></td>				
			    	<td align=center><a href="javascript:setCarOffBank('<%=ht.get("SEQ")%>','<%=ht.get("ACC_NM")%>','<%=ht.get("ACC_SSN")%>','<%=ht.get("ETC")%>','<%=ht.get("BANK_NM")%>','<%=ht.get("ACC_NO")%>','<%=ht.get("ACC_ZIP")%>','<%=ht.get("ACC_ADDR")%>','<%=ht.get("FILE_NAME1")%>','<%=ht.get("FILE_NAME2")%>','<%=ht.get("FILE_GUBUN1")%>','<%=ht.get("FILE_GUBUN2")%>','<%=coe_bean.getCust_st()%>','<%=ht.get("BANK_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("ACC_NM")%></a></td>
			    	<td align=center><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("ACC_SSN")))%></td>
			    	<td align=center><%=ht.get("ETC")%></td>															
			    	<td align=center><%=ht.get("BANK_NM")%></td>
			        <td align=center><%=ht.get("ACC_NO")%></td>
				<td align=center><%=ht.get("ACC_ADDR")%></td>										
			        <td align=center>
			                        <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(attach_ht.get("CONTENT_SEQ")).equals(content_seq+"1")){    									
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}%>
			        </td>
				<td align=center>
			                        <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(attach_ht.get("CONTENT_SEQ")).equals(content_seq+"2")){    									
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}%>			        			        
				
				</td>
            	</tr>
				<%	}%>
				<%	if(vt_size==0){%>
				<tr>
					<td colspan='9' align=center>데이타가 없습니다.</td>
				</tr>
				<%	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td>* <a href="javascript:BankAccMng()" onMouseOver="window.status=''; return true">[실수령인관리]</a></td>
    </tr>	
    <tr> 
        <td align="center"><a href="javascript:window.close();" class="btn"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>