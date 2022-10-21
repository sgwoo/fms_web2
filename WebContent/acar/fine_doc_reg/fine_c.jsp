<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.res_search.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	//��������
	if(!c_id.equals("")){//���� ������ �˻��Ѵ�.		
		rl_bean = fdb.getCarRent(c_id, m_id, l_cd);
	}		
	
	//���·�����
	if(!c_id.equals("") && !seq_no.equals("")){//���� ������ �˻��Ѵ�.			
		f_bean = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd, seq_no);	
	}
	
	//���·� ���ǽ�û����
	if(!c_id.equals("") && !seq_no.equals("")){//���� ������ �˻��Ѵ�.			
		FineDocListBn = FineDocDb.getFineDocList(c_id, seq_no, m_id, l_cd);
		if(!FineDocListBn.getDoc_id().equals("")){
			FineDocBn = FineDocDb.getFineDoc(FineDocListBn.getDoc_id());
		}
		FineGovBn = FineDocDb.getFineGov(f_bean.getPol_sta());
	}
				
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	String content_code = "FINE";
	String content_seq  = m_id+l_cd+c_id+seq_no;
	
	Vector attach_vt = attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_type2 = "";
	String seq2 = "";
	String file_type3 = "";
	String seq3 = "";
	String file_name1 = "";
	String file_name2 = "";
	String file_name3 = "";
	String file_size3 = "";
	
	if(attach_vt_size >0){
		for(int i=0; i< attach_vt.size(); i++){
	    	Hashtable ht = (Hashtable)attach_vt.elementAt(i);   
			
			if((content_seq+1).equals(ht.get("CONTENT_SEQ"))){
				file_name1 = String.valueOf(ht.get("FILE_NAME"));
				file_type1 = String.valueOf(ht.get("FILE_TYPE"));
				seq1 = String.valueOf(ht.get("SEQ"));
				
			}else if((content_seq+2).equals(ht.get("CONTENT_SEQ"))){
				file_name2 = String.valueOf(ht.get("FILE_NAME"));
				file_type2 = String.valueOf(ht.get("FILE_TYPE"));
				seq2 = String.valueOf(ht.get("SEQ"));
				
			}else if((content_seq+3).equals(ht.get("CONTENT_SEQ"))){
				file_name3 = String.valueOf(ht.get("FILE_NAME"));
				file_type3 = String.valueOf(ht.get("FILE_TYPE"));
				seq3 = String.valueOf(ht.get("SEQ"));
				file_size3 = String.valueOf(ht.get("FILE_SIZE"));
			}
		}	
	}

%>
<form action="" name="form1" method="POST" >
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="seq_no" value="<%=seq_no%>">
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='serv_id' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>

    <%if(!f_bean.getRent_s_cd().equals("")){//����ý��� ��� �����̸�
		//�ܱ�������
		RentContBean rc_bean = rs_db.getRentContCase(f_bean.getRent_s_cd(), c_id);
		//������
		RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
		String rent_st = rc_bean.getRent_st();
		if(rent_st.equals("1"))			rent_st = "�ܱ�뿩";
		else if(rent_st.equals("2"))	rent_st = "�������";
		else if(rent_st.equals("3"))	rent_st = "������";
		else if(rent_st.equals("4"))	rent_st = "�����뿩";
		else if(rent_st.equals("5"))	rent_st = "��������";
		else if(rent_st.equals("6"))	rent_st = "��������";
		else if(rent_st.equals("7"))	rent_st = "��������";
		else if(rent_st.equals("8"))	rent_st = "�������";
		else if(rent_st.equals("9"))	rent_st = "�������";
		else if(rent_st.equals("10"))	rent_st = "��������";
		else if(rent_st.equals("12"))	rent_st = "����Ʈ";
	%>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ : <a href="javascript:CarResSearch()">����ý���</a></span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td class=title width="15%">��ȣ</td>
                    <td width="32%">&nbsp;<input type="text" name="res_firm" value="<%=rc_bean2.getFirm_nm()%>" size="30" readonly>
                    </td>
                    <td class=title width="16%">����</td>
                    <td width="37%">&nbsp;<input type="text" name="res_client" value="<%=rc_bean2.getCust_nm()%>" size="30" readonly>
                    </td>
                </tr>
                <tr>
                    <td class=title>��౸��</td>
                    <td>&nbsp;<input type="text" name="res_st" value="<%=rent_st%>" size="30" class=whitetext readonly>
                    </td>
                    <td class=title>�뿩�Ⱓ</td>
                    <td>&nbsp;<input type="text" name="res_sdt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>" size="10" class=whitetext readonly>
                    ~
                      <input type="text" name="res_edt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>" size="10" class=whitetext readonly>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>     <td class=h></td>    </tr>
    <%}%>
    <tr>
        <td width="30%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Ȯ�� �� ��������</span></td>
        <td align="right"><img src=/acar/images/center/arrow_ddj.gif align=absmiddle><font color="#999999"> : ���¿�
            <%if(!f_bean.getFine_st().equals("")){%>
        &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : 
        <input type="text" name="update_id" size="6" value="<%=c_db.getNameById(f_bean.getUpdate_id(), "USER")%>" class=white readonly>
        &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : 
        <input type="text" name="update_dt" size="10" value="<%=AddUtil.ChangeDate2(f_bean.getUpdate_dt())%>" class=white readonly>
        <%}%>
        </font></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td class=line colspan="2">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td class=title width="15%">����</td>
                    <td width="32%">&nbsp;<select name="fine_st" disabled>
                        <option value="1" <%if(f_bean.getFine_st().equals("1"))%>selected<%%>>���·�</option>
                        <option value="2" <%if(f_bean.getFine_st().equals("2"))%>selected<%%>>��Ģ��</option>
                      </select>
                    </td>
                    <td class=title width="16%">���Ȯ�� ��������</td>
                    <td width="37%">&nbsp;<input type="text" name="notice_dt" value="<%if(seq_no.equals("") && f_bean.getNotice_dt().equals("")) {%><%=AddUtil.getDate()%><%}else{%><%=AddUtil.ChangeDate2(f_bean.getNotice_dt())%><%}%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class=title>��������ȣ</td>
                    <td>&nbsp;<input type="text" name="paid_no" value="<%=f_bean.getPaid_no()%>" size="30" class=whitetext style='IME-MODE: inactive'></td>
                    <td class=title>�������</td>
                    <td>&nbsp;<input type="text" name="vio_pla" value="<%=f_bean.getVio_pla()%>" size="30" class=whitetext maxlength="50" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr>
                    <td class=title>�����Ͻ�</td>
                    <td>&nbsp;<input type="text" name="vio_ymd" value="<%=AddUtil.ChangeDate2(f_bean.getVio_dt().substring(0,8))%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type="text" name="vio_s" value="<%=f_bean.getVio_dt().substring(8,10)%>" size="2" maxlength=2 class=whitetext >
                    ��
                    <input type="text" name="vio_m" value="<%=f_bean.getVio_dt().substring(10,12)%>" size="2" maxlength=2 class=whitetext >
                    ��
                    </td>
                    <td class=title>���ݳ���</td>
                    <td>&nbsp;<input type="text" name="vio_cont" value="<%=f_bean.getVio_cont()%>" size="30" class=whitetext onBlur="javascript:set_paid_amt()" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr>
                    <td class=title>û�����</td>
                    <td>&nbsp;<input name="gov_nm" type="text" class=whitetext value="<%if(FineGovBn.getGov_nm().equals("")){%><%=f_bean.getPol_sta()%><%}else{%><%=FineGovBn.getGov_nm()%><%}%>" size="30" maxlength="50" style='IME-MODE: active' onKeyDown='javascript:enter()'>
                        <input type='hidden' name="mng_dept" value=''>
                        <input type='hidden' name="gov_id" value='<%=f_bean.getPol_sta()%>'>
                    </td>
                    <td class=title>�ǰ���������</td>
                    <td>&nbsp;<input type="text" name="obj_end_dt" value="<%=AddUtil.ChangeDate2(f_bean.getObj_end_dt())%>" size="12" maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    ���� </td>
                </tr>
                <%if(!FineDocListBn.getDoc_id().equals("")){%>
                <tr>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<font color=a4005b>[������ȣ] </font><%=FineDocBn.getDoc_id()%> &nbsp;<font color=a4005b>[��������]</font> <%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%> &nbsp;<font color=a4005b>[�μ�����] </font><%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%></td>
                </tr>
                <%}%>
                <%if(!f_bean.getObj_dt1().equals("")){%>
                <tr>
                    <td class=title>���ǽ�û</td>
                    <td colspan="3">&nbsp;1��:
                        <input type="text" name="obj_dt1" value="<%=f_bean.getObj_dt1()%>" size="12" maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    2��:
                    <input type="text" name="obj_dt2" value="<%=f_bean.getObj_dt2()%>" size="12" maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    3��:
                    <input type="text" name="obj_dt3" value="<%=f_bean.getObj_dt3()%>" size="12" maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr>     <td class=h></td>    </tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���·� ����</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td class=title width="15%">���Ǳ���</td>
                    <td width="32%">&nbsp;<select name="fault_st" disabled>
                        <option value="1" <%if(f_bean.getFault_st().equals("1"))%>selected<%%>>������</option>
                        <option value="2" <%if(f_bean.getFault_st().equals("2"))%>selected<%%>>���������</option>
                      </select>
                    </td>
                    <td class=title width="16%">���α���</td>
                    <td width="37%">&nbsp;<select name="paid_st" disabled>
                        <option value="1" <%if(f_bean.getPaid_st().equals("1"))%>selected<%%>>�����ں���</option>
                        <option value="2" <%if(f_bean.getPaid_st().equals("2"))%>selected<%%>>������</option>
                        <option value="4" <%if(f_bean.getPaid_st().equals("4"))%>selected<%%>>���ݳ���</option>
                        <option value="3" <%if(f_bean.getPaid_st().equals("3"))%>selected<%%>>ȸ��볳</option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title>����������</td>
                    <td>&nbsp;<select name='fault_nm' disabled>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(f_bean.getFault_nm().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title>���������ںδ�ݾ�</td>
                    <td>&nbsp;<input type="text" name="fault_amt" value="<%=Util.parseDecimal(f_bean.getFault_amt())%>" size="10" maxlength=10 class=whitenum onBlur="javascript:this.value=parseDecimal(this.value)">
                    ��</td>
                </tr>
                <tr>
                    <td class=title>������ ��������</td>
                    <td>&nbsp;<input type="text" name="rec_dt" value="<%=AddUtil.ChangeDate2(f_bean.getRec_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>���α���</td>
                    <td>&nbsp;<input type="text" name="paid_end_dt" value="<%=AddUtil.ChangeDate2(f_bean.getPaid_end_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    ����</td>
                </tr>
                <tr>
                    <td class=title>���αݾ�</td>
                    <td>&nbsp;<input type="text" name="paid_amt" value="<%=Util.parseDecimal(f_bean.getPaid_amt())%>" size="10" maxlength=6 class=whitenum onBlur="javascript:this.value=parseDecimal(this.value)">
                    ��</td>
                    <td class=title>��������</td>
                    <td>&nbsp;<input type="text" name="proxy_dt" value="<%=AddUtil.ChangeDate2(f_bean.getProxy_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class=title>Ư�̻���</td>
                    <td colspan="3">&nbsp;<%=f_bean.getNote()%><!--<textarea name="note" cols=100 rows=2 class=default></textarea>-->
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>     <td class=h></td>    </tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�볳���·� ����</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td class=title colspan="2">û������</td>
                    <td width="32%">&nbsp;<input type="text" name="dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getDem_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width="16%">����û����</td>
                    <td width="11%">&nbsp;<input type="text" name="f_dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getF_dem_dt())%>" size="12" class=whitetext readonly>
                    </td>
                    <td class=title width="15%">����û����</td>
                    <td width="11%">&nbsp;<input type="text" name="e_dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getE_dem_dt())%>" size="12" class=whitetext readonly>
                    </td>
                </tr>
                <tr>
                    <td class=title colspan="2">�Աݿ�����</td>
                    <td>&nbsp;<input type="text" name="rec_plan_dt" value="<%=AddUtil.ChangeDate2(f_bean.getRec_plan_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>��������</td>
                    <td colspan="3">&nbsp;<input type="text" name="coll_dt" value="<%=AddUtil.ChangeDate2(f_bean.getColl_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class=title rowspan="2" width="6%">����<br>
                    ��꼭</td>
                    <td class=title width="9%">���࿩��</td>
                    <td>&nbsp;<select name="tax_yn" disabled>
                        <option value="0" <%if(f_bean.getTax_yn().equals("0"))%>selected<%%>>�̹���</option>
                        <option value="1" <%if(f_bean.getTax_yn().equals("1"))%>selected<%%>>����</option>
                      </select>
                    </td>
                    <td class=title>�ΰ��� ���Կ���</td>
                    <td colspan="3">&nbsp;<select name="vat_yn" disabled>
                        <option value="0" <%if(f_bean.getVat_yn().equals("0"))%>selected<%%>>������</option>
                        <option value="1" <%if(f_bean.getVat_yn().equals("1"))%>selected<%%>>����</option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title>�ŷ�����</td>
                    <td>&nbsp;<select name="busi_st" disabled>
                        <option value="1" <%if(f_bean.getBusi_st().equals("1"))%>selected<%%>>���·�</option>
                        <option value="2" <%if(f_bean.getBusi_st().equals("2"))%>selected<%%>>��������</option>
                      </select>
                    </td>
                    <td class=title>�ŷ��������Կ���</td>
                    <td colspan="3">&nbsp;<select name="bill_doc_yn" disabled>
                        <option value="0" <%if(f_bean.getBill_doc_yn().equals("0"))%>selected<%%>>������</option>
                        <option value="1" <%if(f_bean.getBill_doc_yn().equals("1"))%>selected<%%>>����</option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title colspan="2">��������</td>
                    <td colspan="5">&nbsp;<input type='checkbox' name='no_paid_yn' value="Y" <%if(f_bean.getNo_paid_yn().equals("Y"))%>checked<%%>>
                    ����:
                      <input type="text" name="no_paid_cau" value="<%=f_bean.getNo_paid_cau()%>" size="60" class=whitetext >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>     <td class=h></td>    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="15%">������/������</td>
                    <td>
						  <%if(!file_name1.equals("")){%>	
						  &nbsp;					  	
						  <%	if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
							 	<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='����' ><%=file_name1%></a>
							<%	}else{%>
							 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
							<%	}%>								  
						  <%}%>							
						  <%if(!file_name3.equals("")){%>	
						  &nbsp;					  
						  <%	if(file_type3.equals("image/jpeg")||file_type3.equals("image/pjpeg")||file_type3.equals("application/pdf")){%>
							 	<a href="javascript:openPopP('<%=file_type3%>','<%=seq3%>');" title='����' ><%=file_name3%></a>
							<%	}else{%>
							 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq3%>" target='_blank'><%=file_name3%></a>
							<%	}%>								  
						  <%}%>
					</td>                    
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td colspan="2">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td align=right><a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a>            </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>

