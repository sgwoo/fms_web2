<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 1);
		
	//��ü����Ʈ
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);

	
	String rent_st = "";
	int cls_per = 0;
	
	int start_dt = 0;	
	
	long amt3[]   = new long[9];
	
	int amt_1 = 0;
	int amt_2 = 0;
	int amt_3 = 0;
	int amt_4 = 0;
	int amt_5 = 0;
	int amt_6 = 0;
	int amt_7 = 0;
	long amt_i = 0;
	

%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�Ƹ���ī ������� �� �����ְ� �ȳ���</title>
<style type="text/css">
<!--
.style1 {color: #88b228}
.style2 {color: #747474}
.style3 {color: #ffffff}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
.style15 {color: #334ec5;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- �� FMS�α��� ��ư -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=https://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
 
    <tr>
        <td height=5 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=30></td>
                </tR>
                <tr>
                    <td align=center>
                        <table width=677 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_bg.gif>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_1.gif></td>
                            </tr>
                            <tr>
                                <td height=40></tD>
                            </tr>
                            <tr>
                                <td align=center>
                                    <table width=619 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=92><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t1.gif></td>
                                            <td><span class=style15><%=FineDocBn.getDoc_id()%> </span></td>
                                        </tr>
                                        <tr>
                                            <td height=3 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td width=92><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t4.gif></td>
                                            <td><span class=style15><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></span></td>
                                        </tr>
                                        <tr>
                                            <td height=3 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t2.gif></td>
                                            <td><%=FineDocBn.getGov_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td><%=FineDocBn.getGov_addr()%></td>
                                        </tr>
                                        <tr>
                                            <td height=3 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t3.gif></td>
                                            <td>(��)�Ƹ���ī ��ǥ�̻� ������</td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>����Ư���� �������� �ǻ���� 8, ����̾ؾ����� 8�� 802ȣ (���ǵ���)</td>
                                        </tr>
                                        <tr>
                                            <td height=3 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t5.gif></td>
                                            <td><%=FineDocBn.getTitle()%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align=center height=40><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_line.gif></td>
                            </tr>
                            <tr>
                                <td align=center>
                                    <table width=648 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=45>&nbsp;&nbsp;1. ���� �ͻ�(����)�� ������ �ŷ����谡 ���ӵǵ��� �ּ��� ����� ���ؿ�����, �� �� ������� �� �����ְ�<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ �Ǿ����� ���������� �����մϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;2. ���� �ͻ�(����)���� ���̿� ü���� �ڵ����뿩��� �ֿ䳻���� �Ʒ� ǥ�� �����ϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=105 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>����</b></span></td>
                                                        <td width=96 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>������ȣ</b></span></td>
                                                        <td height=22 colspan=3 align=center bgcolor=f6ebcc><span class=style10><b>�뿩�̿���Ⱓ</b></span></td>
                                                        <td width=80 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>������</b></span></td>
                                                        <td width=80 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>���ô뿩��</b></span></td>
                                                        <td width=82 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>���뿩��</b></span></td>
                                                    </tr>
                                                    <tr bgcolor=#FFFFFF>
                                                        <td width=72 height=22 align=center bgcolor=f6ebcc><span class=style10><b>������</b></span></td>
                                                        <td width=72 align=center bgcolor=f6ebcc><span class=style10><b>������</b></span></td>
                                                        <td width=52 align=center bgcolor=f6ebcc><span class=style10><b>���</b></span></td>
                                                    </tr>
  <% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
												
					//cont
					Hashtable base = a_db.getContViewCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
					
					rent_st = FineDocDb.getMaxRentSt(FineDocListBn.getRent_l_cd());
					
					ContFeeBean fee = a_db.getContFeeNew(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), rent_st);
					
					ContEtcBean cont_etc = a_db.getContEtc(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
					
					cls_per = (int) fee.getCls_r_per();
					
					Hashtable ht2 = s_db.getContSettleCase1("2", FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd() , "", "1", "6", FineDocBn.getDoc_dt());
					//��ü�� ����
					Hashtable ht3 = s_db.getContSettleCase2("",FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd() , "", "1", "6", FineDocBn.getDoc_dt());
				
				
					for(int j=0; j<9; j++){
							amt3[j]  += AddUtil.parseLong(String.valueOf(ht3.get("EST_AMT"+j)));
					}
					
					if (amt3[2]- amt3[8]  < 0  ) {
					    amt_i = 0;
					} else {
				   		amt_i = amt3[2]-amt3[8];
					}
				
					amt_2 += FineDocListBn.getAmt2();
					amt_3 += FineDocListBn.getAmt3();
					amt_4 += FineDocListBn.getAmt4();
					amt_5 += FineDocListBn.getAmt5();
					amt_7 += FineDocListBn.getAmt7(); //��ü����
					
					if ( amt_7 > 0 ) {
						  amt_i = amt_7;   
					}	
								
%>	
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=#FFFFFF><span class=style12><%=base.get("CAR_NM")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style11><%=base.get("CAR_NO")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("RENT_START_DT")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("RENT_END_DT")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("CON_MON")%>����</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getGrt_amt_s())%>&nbsp;</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>&nbsp;</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>&nbsp;</span></td>
                                                       
                                                    </tr>
<%
start_dt = AddUtil.ChangeStringInt(String.valueOf(base.get("RENT_START_DT")));
if(!cont_etc.getRent_suc_dt().equals("")){
	start_dt = AddUtil.parseInt(cont_etc.getRent_suc_dt());	
}
%>                                                     
<% 		}
	} %>                                                    
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=105 align=center bgcolor=f6ebcc height=35><span class=style10><b>�ߵ���������</b></span></td>
                                                        <td colspan=3 bgcolor=ffffff>&nbsp;<span class=style12>���뿩�Ḧ 30�� �̻� ��ü�� �� ����� ���� �� �뿩���� ������ ȸ��</span></td>
                                                    </tr>
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=f6ebcc><span class=style10><b>��ü������</b></span></td>
                                                        <td align=center bgcolor=#FFFFFF width=214><span class=style12><%if(start_dt < 20081010 ) {%>�� 18%<%}else if(start_dt >= 20081010 && start_dt < 20220101) {%>�� 24%<%}else{%>�� 20%<%}%></span></td>
                                                        <td align=center bgcolor=f6ebcc width=80><span class=style10><b>�����</b></span></td>
                                                        <td align=center bgcolor=#FFFFFF width=244><span class=style12>�ܿ��Ⱓ �뿩�� �Ѿ��� (<%=cls_per%>)%</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tR>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;3. �ͻ�(����)�� <span class=style15><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%> ���� �̳� �ݾ�</span>�� �Ʒ� ǥ�� �����ϴ�. </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=135 align=center bgcolor=f6ebcc height=35><span class=style10><b>��ü�뿩��</b></span></td>
                                                        <td align=right width=186 bgcolor=ffffff>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_2)%> ��&nbsp;</span></td>
                                                        <td width=135 align=center bgcolor=f6ebcc><span class=style10><b>��ü����</b></span></td>
                                                        <td align=right width=187 bgcolor=ffffff>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_i)%> ��&nbsp;</span></td>
                                                    </tr>
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=f6ebcc><span class=style10><b>�������ݰ��·� ��</b></span></td>
                                                        <td align=right bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_3)%> ��&nbsp;</span></td>
                                                        <td align=center bgcolor=f6ebcc><span class=style10><b>��å��</b></span></td>
                                                        <td align=right bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_4)%> ��&nbsp;</span></td>
                                                    </tr>
                                                 
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=f6ebcc><span class=style10><b>���������</b></span></td>
                                                        <td align=right bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_5)%> ��&nbsp;</span></td>
                                                        <td align=center bgcolor=f6ebcc><span class=style10><b>�հ�</b></span></td>
                                                        <td align=right bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_2+amt_3+amt_4+amt_5+amt_i)%> ��&nbsp;</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tR>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;4. ���α��� �� �뿩���� ȸ�� �������ڴ� �Ʒ� ǥ�� �����ϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=135 align=center bgcolor=f6ebcc height=35><span class=style10><b>���α���</b></span></td>
                                                        <td width=186 bgcolor=fffff>&nbsp;<span class=style12><%=AddUtil.getDate3(FineDocBn.getEnd_dt())%></span></td>
                                                        <td width=135 align=center bgcolor=f6ebcc><span class=style10><b>�뿩����ȸ��������</b></span></td>
                                                        <td width=187 bgcolor=fffff>&nbsp;<span class=style12><%=AddUtil.getDate3(due_dt)%></span></td>
                                                    </tr>
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=f6ebcc><span class=style10><b>�Աݰ��¹�ȣ</b></span></td>
                                                        <td bgcolor=#fffff colspan=3>&nbsp;<span class=style12>&nbsp;���� 140-004-023871</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tR>
                                        <tr>
                                            <td height=60>&nbsp;&nbsp;5. �ͻ�(����)�� ����� ������ �ȳ����� �ұ��ϰ� �������� ��� �̳��ݾ��� �������� �ʰ� ������, ���� �� �� ����<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ������ ����� ������ �ް� �ֽ��ϴ�. �̿� ���� ��� ���α��� �ϱ��� �̳��ݾ� ���θ� ������ ���� �ְ� �ϴ�<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���̸�, ���� �������� ���� ��� ��� �ڵ����뿩����� ������ �����뺸���� �ڵ����� ������ ���Դϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tR>
                                        <tr>
                                            <td height=50>&nbsp;&nbsp;6. �� �Ͻñ��� �̳��ݾ� ���θ� �������� ���� ��� ���� �ͻ�(����)�� ���뺸������ ���� �Ρ������&nbsp; ����������<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� �ڱ������� �����ϰ�, �̿� ������ �����&nbsp;(���з�, ���ǰ�� ���� �Ҽ۰��� �����, &nbsp;����ȸ�� ��&nbsp; ������Ź��<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ���� ����� �� ����)������ û���� �����̸�,��쿡 ���� ��������� û�� �� �ſ������� � ä�������� ���<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �뺸 �� ������ �����̹Ƿ� �ſ�� ū �������� ���� �� ������ �˷��帳�ϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;<span class=style7>�� ����ó : ������� ������ 02-6263-6383</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20></td>
                                        </tr>
                                        <tr>
                                            <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_ceo.gif></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=20></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_2.gif></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <!--
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href=mailto:tax@amazoncar.co.kr><span class=style14>���Ÿ���(tax@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</span></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>-->
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>