<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 0);
	String due_dt2 = c_db.addDay(FineDocBn.getEnd_dt(), 1);
	
	//��ü����Ʈ
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);

	
	String rent_st = "";
	int cls_per = 0;
	int de_day = 0;
	
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
<title>�Ƹ���ī ������� �� �����ݳ��뺸 �ȳ���</title>
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
table td{font-size:10.7pt;}
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
 <!--   
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
    	 
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/images/ment_02.gif width=414 height=12></td>
                    <td width=250 align=right><span class=style2><b><%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%></b></span>&nbsp;&nbsp;&nbsp;</td>
                </tr> 
            </table>
   
        </td>
    </tr>
  -->  
  <!--
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=454 valign=top>
                        <table width=454 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=14><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_left_up.gif width=14 height=16></td>
                                <td width=440 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_up_bg.gif>&nbsp;</td>
                            </tr>
                            <tr>
                                <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_bg.gif>&nbsp;</td>
                                <td align=center>
                                    <table width=411 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td height=50 align=left>&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/pay/images/info_title_h.gif></td>
                                        </tr>
                                  
                                        <tr>
                                            <td height=30 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span class=style1><span class=style1><b><%=c_db.getNameById(FineDocBn.getGov_id(), "CLIENT")%></b></span>&nbsp;<span class=style2>�� ����</span> </span></td>
                                        </tr>
                                 
                                        <tr>
                                            <td height=11></td>
                                        </tr>
                                        <tr>
                                            <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_line_up.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor=f7f7f7>
                                                <table width=411 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan=3 height=16></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=12>&nbsp;</td>
                                                        <td width=386 align=left>
                                                            <table width=386 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=18><span class=style2>���� �ͻ�(����)�� ������ �ŷ����谡 ���ӵǵ��� �ּ��� ���ؿ�����</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>�Ʒ��� ���� ������� �� �����ְ��� ������ �Ǿ����� ����������</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>�����մϴ�. </span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=12>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 height=14></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_line_dw.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_left_dw.gif width=14 height=16></td>
                                <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_dw_bg.gif>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width=36 valign=top>
                        <table width=36 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_bg.gif>
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_right_up.gif width=36 height=16></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                            </tr>
                            <tr>
                                <td height=129></td>
                            </tr>
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_right_dw.gif width=36 height=16></td>
                            </tr>
                        </table>
                    </td>
                    <td width=187 valign=top>
            			<table width=187 border=0 cellpadding=0 cellspacing=0 bgcolor=574d89>
                            <tr>
                                <td width=187 bgcolor=594e8a>
                                    <table width=187 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=16 background=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_up_bg.gif></td>
                                        </tr>
                                        <tr>
                                            <td height=16><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/sup_img1.gif width=187 height=51></td>
                                        </tr>
                                        <tr>
                                            <td height=40 align=left></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/car_adm/images/sup.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=4></td>
                                        </tr>
                               
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong>������</strong></span> </td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong>02)392-4243</strong></span></td>
                                        </tr>
                                        <tr>
                                            <td height=48></td>
                                        </tr>
                         
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=16 background=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_dw_bg.gif>&nbsp;</td>
                            </tr>
                        </table>
            		</td>
                </tr>
            </table>
        </td>
    </tr>
   --> 
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_r_1.gif></td>
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
                                            <td><%=FineDocBn.getGov_nm()%>&nbsp;<%=FineDocBn.getMng_dept()%></td>
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
                                            <td>����Ư���� �������� �ǻ���� 8, ������� 8�� 802ȣ (���ǵ���)</td>
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
                                            <td height=45>&nbsp;&nbsp;1. ���� �ͻ�(����)�� ������ �ŷ����谡 ���ӵǵ��� �ּ��� ���� ������, &nbsp;�� �� ������� �� 
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;�����ݳ��뺸�� ������ �Ǿ����� ���������� �����մϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;2. �����ϴٽ��� �Ʒ��� ���� �ͻ�(����)�� ������ ���̿� �ڵ��� �뿩�̿����� ü���Ͽ�����
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��.</td>
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
						
					Hashtable base1 = as_db.getSettleBase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), "", "");
					de_day  =	AddUtil.parseInt((String)base1.get("S_MON")) * 30  +   AddUtil.parseInt((String)base1.get("S_DAY")); 
																	
					//cont
					Hashtable base = a_db.getContViewCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
					
					rent_st = FineDocDb.getMaxRentSt(FineDocListBn.getRent_l_cd());
					
					ContFeeBean fee = a_db.getContFeeNew(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), rent_st);
					
					ContEtcBean cont_etc = a_db.getContEtc(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
					
					cls_per = (int)fee.getCls_r_per();
						
					amt_6 += FineDocListBn.getAmt6();
				
								
%>	
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=#FFFFFF><span class=style12><%=base.get("CAR_NM")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style11><%=base.get("CAR_NO")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("RENT_START_DT")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("RENT_END_DT")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("CON_MON")%>����</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getGrt_amt_s())%> ��&nbsp;</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%> ��&nbsp;</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%> ��&nbsp;</span></td>
                                                       
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
                                                        <td align=center bgcolor=#FFFFFF width=244><span class=style12>�ܿ��Ⱓ �뿩�� �Ѿ��� (<%=cls_per%>) %</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tR>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;3. �׷���, �ͻ�(����)�� �뿩�Ḧ (<span class=style15><%=de_day%></span>)�� �̻� �������� �ʰ� �־ ���� �ͻ�(����)�� �� �̻� 
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;�����踦 ������ �� ������ ��� �ߵ����� ������ �����Ͽ� �ߵ����� �뺸�մϴ�.<br>
                                           </td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;4. �ͻ�(����)�� <b><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></b>&nbsp;���� �����������&nbsp;(&nbsp;<b><%=Util.parseDecimal(amt_6)%></b>&nbsp;) �� �Դϴ�.</td>
                                        </tr>
                                       <!-- <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=321 align=center bgcolor=f6ebcc height=35><span class=style10><b>���������</b></span></td>
                                                        <td align=center bgcolor=ffffff>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_6)%> ��</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td align=right><span class=style12>* ��� ����������� ���� ȸ���ϱ��� �������� �˷��帳�ϴ�.</span>&nbsp;&nbsp;&nbsp;</td>
                                        </tr>-->
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td height=50>&nbsp;&nbsp;5. �Ʒ� �Ͻñ��� ������ �ݳ��� ���� �뺸�ϸ�, &nbsp;�ݳ� ���� ���� ��� �ͻ�(����)���� <span class=style15>��� ����å��
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Ⱦ���˷� ���� ��ҵ�)</span>�� ���� ���Դϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                            
                           <tr bgcolor=ffffff>
                                <td style="font-size : 9pt;" align=center bgcolor=f6ebcc colspan=2 height=25><span class=style10><b>�����ݳ�����</b></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2>&nbsp;<span class=style12><%=AddUtil.getDate3(due_dt)%></span></td>
								<td style="font-size : 9pt;" align=center bgcolor=f6ebcc colspan=2 height=25><span class=style10><b>�����������࿹����</b></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2>&nbsp;<span class=style12><%=AddUtil.getDate3(due_dt2)%></span></td>
                          </tr>
                           
                        </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tR>
                                        <tr>
                                            <td height=60>&nbsp;&nbsp;6. �� �Ͻñ��� �����ݳ��� �ȵɽ� ���� �ͻ�(����)�� &nbsp;���뺸������ ���� &nbsp;�Ρ������ &nbsp;��������
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;���� �� �ڱ������� �����ϰ�, &nbsp;�̿� ������ &nbsp;�����(���з�,&nbsp; ���ǰ�� ���� &nbsp;�Ҽ۰��� �����,
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;����ȸ�� �� ������Ź�� ���� ����� �� ����)�� ���� û���� �����̸�, ��쿡 ����  ��������û��
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;�� �ſ���������� ä�� �߽��Ƿڿ� ä�������� ������ ����� ���̸�, ä�������� ���� ��� �� 
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;���� �ſ� ���� �Ǵ� ����ſ����� �϶��ϰ� �ݸ��� ����ϴ� ���� �������� �߻� �� �� ������ 
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;�˷��帳�ϴ�. </td>                                                                          
                                            
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;<span class=style7>�� ����ó : ������� ������ 02-6263-6383</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        
                                        <tr>
                                            <td align=right><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_ceo_1.gif></td>
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
                    <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=523><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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